## -*- Mode: octave -*-

## This loads the Compass data, making all values of counts (such as
## numbers of misdemeanours) larger than some threshold
## equivalent. This is mainly done to accommodate the discrete
## Bayesian network model. However, the Bayesian regressor could be
## run as is.

function X = TruncateDiscreteData(fname, indices, max_counts)
  X = load(fname);
  X(:, indices) = min(X(:, indices), max_counts);
end
