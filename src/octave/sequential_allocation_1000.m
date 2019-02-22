%% -*- Mode: octave -*-

pkg load parallel;


A = 2;
X = 8;
Y = 2;
Z = 2;


lambda = [0 0.25 0.5 0.75 1];
period = 1 * ones(1,5);
horizon = 1000 * ones(1,5);
alpha = [1.0 1.0 1.0 1.0 1.0];
n_iter = 10000 * ones(1,5);
n_samples = 16 * ones(1,5);

for k=1:10
  true_model = GenerateDiscreteModel(X, Y, Z);
  fname = ["seq-random-10000-iter-1000-steps-16-samples-1.0-alpha-run-", num2str(k), ".dat"]
  results = pararrayfun(8, @SequentialSamplingDirichlet, A, X, Y, Z, true_model, lambda, n_iter, horizon, period, alpha, n_samples);
  %results = SequentialSamplingDirichlet(A, X, Y, Z, true_model, lambda(1), n_iter(1), horizon(1), period(1), alpha(1), n_samples(1));
  save (fname, "results", "true_model");
end




