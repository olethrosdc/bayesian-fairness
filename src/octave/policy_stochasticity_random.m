%% -*- Mode: octave -*-

pkg load parallel;

%{

This code compares the marginal and credible fairness rules for the COMPAS dataset.



%}

%% The attributes are all discrete numerical or categorical variables.
%%attrs = { "sex", "age_cat", "race", "juv_fel_count", "juv_misd_count", "juv_other_count", "priors_count", "c_charge_degree", "two_year_recid"};
printf("Loading data\n");

X = 8;
Y = 2;
Z = 2;
A = 2;
n_data = 10000;
options.model = GenerateDiscreteModel(X, Y, Z);
[data.x, data.y, data.z] = GenerateData(options.model, repmat([1;0], 1, X), n_data);
options.utility = eye(A);
options.base_name = "stochasticity-test";
period = 100;
alpha = 1;
n_iter = 10000;

results = ConvergenceEvaluationDirichletFromData(options.model, data, options.utility, lambda, n_iter, period, alpha);

save("stochasticity-test-results.dat", "options", "results")




