%% -*- Mode: octave -*-

arg_list = argv ();

A = 2;
X = 8;
Y = 2;
Z = 2;
n_models = 8;
K = 5;
n_iter = 10000;
horizon=100;
[PU, PF, PV] = ConvergenceEvaluationFixedData(A, X, Y, Z, n_models, K, n_iter, horizon);

fname=arg_list{1}

save (fname, "PU", "PF", "PV")


