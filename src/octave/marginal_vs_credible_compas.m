%% -*- Mode: octave -*-

pkg load parallel;

%{

This code compares the marginal and credible fairness rules for the COMPAS dataset.



%}

%% The attributes are all discrete numerical or categorical variables.
%%attrs = { "sex", "age_cat", "race", "juv_fel_count", "juv_misd_count", "juv_other_count", "priors_count", "c_charge_degree", "two_year_recid"};
printf("Loading data\n");
original_data = TruncateDiscreteData("../../data/compas.csv", [4:7], 2); % make attributes 4-7 binary
%% Select the attributes for each variable and 
Z_attr = [1, 3]; % sex, race
X_attr = [2, 4, 5, 6, 7, 8]; % age jf jm jo pc c
Y_attr = [9];
[decision_problem, AllData] = CompactDiscreteData(original_data, Z_attr, X_attr, Y_attr); % AllData in format [z x y]

penalty_violation = 1; % discourage letting risky criminals out
penalty_jail = 0.5; %discourage putting everybody in jail
% note that if the penalty is smaller, say 0.1, then we end up just putting everybody in jail!
decision_problem.util = eye(2); %GenerateRecidivismProblemUtility(penalty_violation, penalty_jail);
decision_problem.n_a = 2; % release, or not
n_x = decision_problem.n_x;
n_y = decision_problem.n_y;
n_z = decision_problem.n_z;
n_a = decision_problem.n_a;

%% data is D x is continuous y, z are discrete. So log. regression is
%% x -> (y,z) It's easier to write it like this:
%%
%% Bayesian:
%% min_w sum_v P(v | D) {sum_x P_w(a | x) [P_v(x | y, z) - P_v(x | y)]}
%%
%% ML: v = argmax_v P_v(D)
%% min_w {sum_x P_w(a | x) [P_v(x | y, z) - P_v(x | y)]}
%%
%% If you use this formulation, it is more natural to use e.g. a
%% Gaussian model x | y,z pair. So, no regression
%%
%% but we can also write in terms of P_v(y | x) P_v(x) etc...
%%
%% So I need a way to: sample from P(v | D), the posterior distribution of the parameters, and a way to calculate, for any given v, the term P_v(x | y, z) - P_v(x | y)
%% 1. Bayesian way: calculate P(v | D) = P_v(D) P(V) / Z (must approximate)
%% 2. Bootstrapping: split dataset in k bootstrap samples {D_i}, and for each sample calculate v_i = argmax_v P_v(D_i), and then you have an approximate sample {v_i} from the approximate Boostrap posterior

dirichlet_mass = 0.5;
prior_belief = InitialiseDirichletBelief(n_x, n_y, n_z, dirichlet_mass);

% since we don't have the real model, we use the test part of the data to estimate performance
TrainData = AllData(1:6000, :);
TestData = AllData(6001:7214, :);
printf("Fitting model\n"); fflush(stdout);
test_data.x = TestData(:,2);
test_data.y = TestData(:,1);
test_data.z = TestData(:,3);
test_belief = DirichletPosteriorBelief(prior_belief, test_data.x, test_data.y, test_data.z);
test_model = CalculateMarginalModelDirichlet(test_belief);

train_data.x = TrainData(:,2);
train_data.y = TrainData(:,1);
train_data.z = TrainData(:,3);


lambda = repmat([0.5 0.25 0.5 0.75 1], 1, 4);
period = [repmat([100], 1, 10) repmat([1], 1, 10)];
alpha = repmat([1.0, 0.1], 1, 10);
n_iter = 400 * ones(1,20);
options.model = test_model;
options.data = train_data;
options.utility = decision_problem.util;
options.base_name = "compas-fixed-";
results = ConvergenceEvaluationDirichletFromData(test_model, train_data, decision_problem.util, lambda(1), n_iter(1), period(1), alpha(1), "test-results.dat")
#results = pararrayfun(8, @ConvergenceEvaluationDirichletFromDataPar, options, lambda, n_iter, period, alpha);
#ConvergenceEvaluationDirichletFromDataPar(options, lambda(1), n_iter(1), period(1), alpha(1));







