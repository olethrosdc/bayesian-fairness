%% -*- Mode: octave -*-

function dependence = Fairness(policy, model, model_delta)
  A = rows(policy);
  X = columns(policy);
  dependence = 0;
  for y=1:model.Y
	for z=1:model.Z
	  delta = policy * model_delta(:, y, z);
	  dependence += norm(delta, 1);
	end
  end
end
