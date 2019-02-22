%% -*- Mode: octave -*-

%% Generate dat a from the policyllrueel
function belief = GeneratePosteriorFromPolicy(belief, model, policy, n_data, target_model = 0)
  n_models = length(model);
  if (target_model)
	M = target_model;
  else
	if (n_models > 1) 
	  M = discrete_rnd([1:n_models], belief, 1);
	else
	  M = 1;
	end
  end
  [x, y, z] = GenerateData(model{M}, policy, n_data);
  T = columns(x);
  for t = 1:T
	for m=1:n_models
	  belief(m) *= model{m}.Pxyz(x(t), y(t), z(t));
	end
	belief /= sum(belief);
  end
end
