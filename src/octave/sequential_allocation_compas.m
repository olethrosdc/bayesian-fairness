%% -*- Mode: octave -*-


A = 2;
X = 8;
Y = 2;
Z = 2;


lambda = 0.5;
period = 100;
horizon = 10000;
alpha = 1.0;
n_iter = 10000;
n_samples = 1;

true_model = GenerateDiscreteModel(X, Y, Z);
results = SequentialSamplingDirichlet(A, X, Y, Z, lambda, n_iter, horizon, period, alpha, true_model, n_samples);

bayes_results = SequentialSamplingDirichlet(A, X, Y, Z, lambda, n_iter, horizon, period, alpha, true_model, 16);

