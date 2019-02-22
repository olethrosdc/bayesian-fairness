%% -*- Mode: Octave -*-
%%
%% Calculate the marginal model from a belief over a set M of models
function model = CalculateMarginalModel(M, belief)
  model = M{1};
  n_models = length(belief);
  for x=1:model.X
	for y=1:model.Y
	  for z=1:model.Z
		model.Pxyz(x, y, z) = 0;
		for i=1:n_models
		  model.Pxyz(x, y, z) += belief(i) * M{i}.Pxyz(x, y, z);
		end
	  end
	end
  end
  model = CalculateModelMarginals(model);
end
