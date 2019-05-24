%% -*- Mode: octave -*-

%{

This code compares the marginal and credible fairness rules for the COMPAS dataset.



%}

%% The attributes are all discrete numerical or categorical variables.
%%attrs = { "sex", "age_cat", "race", "juv_fel_count", "juv_misd_count", "juv_other_count", "priors_count", "c_charge_degree", "two_year_recid"};
printf("Loading data\n");
original_data = TruncateDiscreteData("../../data/compas.csv", [4:7], 2); % make attributes 4-7 binary
%% Select the attributes for each variable and 
Z_attr = [1, 3];
X_attr = [2, 4, 5, 6, 7, 8];
Y_attr = [9];
[decision_problem, AllData] = CompactDiscreteData(original_data, Z_attr, X_attr, Y_attr); % AllData in format [z x y]

penalty_violation = 0.1; % discourage letting risky criminals out
penalty_jail = 1; %discourage putting everybody in jail
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
TrainData = AllData(1:100, :);
TestData = AllData(6001:7214, :);
printf("Fitting model\n"); fflush(stdout);

%% Fit the training data
train_data.x = TrainData(:,2);
train_data.y = TrainData(:,1);
train_data.z = TrainData(:,3);
train_belief = DirichletPosteriorBelief(prior_belief, train_data.x, train_data.y, train_data.z);
train_model = CalculateMarginalModelDirichlet(train_belief);


%% Fit the test data
test_data.x = TestData(:,2);
test_data.y = TestData(:,1);
test_data.z = TestData(:,3);
test_belief = DirichletPosteriorBelief(prior_belief, test_data.x, test_data.y, test_data.z);
test_model = CalculateMarginalModelDirichlet(test_belief);

%% GD parameters
alpha = 1;
n_iter = 10000;

lambdas = [0 0.25 0.5 0.75 1];
for k=1:5
  lambda = lambdas(k);
  filename=["convergence-", num2str(lambda), "-100-"];

  [marginal, bayes] = GradientDescentTest(test_model, train_belief, decision_problem.util, 2, lambda, n_iter, alpha);

  plot(bayes.results.PV, '-', "linewidth", 2, marginal.results.PV, '--', "linewidth", 3);
  print ([filename, "V.pdf"], "-S320,240", "-tight");
  print ([filename, "V.tikz"], "-S320,240", "-tight");
  print ([filename, "V.eps"], "-S320,240", "-tight");
  matlab2tikz ([filename, "V.tex"], "width", "\fwidth");

  plot(bayes.results.PU, '-', "linewidth", 2, marginal.results.PU, '--', "linewidth", 3);
  print ([filename, "U.pdf"], "-S320,240", "-tight");
  print ([filename, "U.tikz"], "-S320,240", "-tight");
  print ([filename, "U.eps"], "-S320,240", "-tight");
  matlab2tikz ([filename, "U.tex"], "width", "\fwidth");

  plot(bayes.results.PF, '-', "linewidth", 2, marginal.results.PF, '--', "linewidth", 3);
  print ([filename, "F.pdf"], "-S320,240", "-tight");
  print ([filename, "F.tikz"], "-S320,240", "-tight");
  print ([filename, "F.eps"], "-S320,240", "-tight");
  matlab2tikz ([filename, "F.tex"], "width", "\fwidth");
endfor


