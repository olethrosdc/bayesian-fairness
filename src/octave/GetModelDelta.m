%% Get the delta of a model

function delta = GetModelDelta(model)
  delta = model.Px_y - model.Px_yz;
  %% Apparently the above applies the correct transformation of the matrix
  %% delta = zeros(model.X, model.Y, model.Z);
  
  %% for x=1:model.X
  %%   for y=1:model.Y
  %% 	  for z=1:model.Z
  %% 		delta(x, y, z) = model.Px_y(x, y) - model.Px_yz(x, y,z);
  %% 	  end
  %% 	end
  %% end
end
