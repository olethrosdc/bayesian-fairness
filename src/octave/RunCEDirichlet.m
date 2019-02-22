%% -*- Mode: octave -*-

arg_list = argv ();
fname = arg_list{1};
lambda = str2num(arg_list{2});

A = 2; % number of actions
X = 8; % number of observations
Y = 2; % number of classes
Z = 2; % number of sensitive attributes
n_iter = 10000; % GD iterations
horizon=1000; % amount of data

% Run the experiment on a randomly generated model
[PU, PF, PV] = ConvergenceEvaluationDirichlet(A, X, Y, Z, lambda, n_iter, horizon);

save (fname, "PU", "PF", "PV")
