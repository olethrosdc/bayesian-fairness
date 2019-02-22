%% -*- Mode: octave -*-

%% Generate data from the policy

function belief = GenerateDirichletPosteriorFromPolicy(belief, policy, data)
  n_models = length(model);
  x = data(:, 1);
  y = data(:, 2);
  z = data(:, 3);
  T = columns(x);
  for t = 1:T
	belief.Nxyz = P(x(t),y(t),z(t))
  end
end
