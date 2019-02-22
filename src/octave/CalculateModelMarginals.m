%% -*- Mode: Octave -*-
%%
%% Calculate all marginal and conditional distributions between xyz
%%from their joint distribution
function model = CalculateModelMarginals(model)
  model.Px_yz = zeros(model.X, model.Y, model.Z);
  model.Pz_xy = zeros(model.Z, model.X, model.Y);
  model.Pz_y = zeros(model.Z, model.Y);
  model.Pyz = zeros(model.Y, model.Z);
  model.Px_y = zeros(model.X, model.Y);
  model.Py_x = zeros(model.Y, model.X);
  model.Pxy = zeros(model.X, model.Y);
  model.Py = zeros(model.Y, 1);
  model.Px = zeros(model.X, 1);
  
  for y=1:model.Y
	for z=1:model.Z
	  model.Pyz(y, z) = sum(model.Pxyz(:, y,z));
	end
  end
  for x=1:model.X
    for y=1:model.Y
	  for z=1:model.Z
		model.Px_yz(x, y, z) = model.Pxyz(x, y,z) / model.Pyz(y, z);
	  end
	end
  end

  for x=1:model.X
	model.Px(x) = sum(sum(model.Pxyz(x, :, :)));
  end
  
  for y=1:model.Y
    model.Py(y) = sum(sum(model.Pxyz(:, y, :)));
    for x=1:model.X
	  model.Pxy(x,y) =  sum(model.Pxyz(x, y, :));
      model.Px_y(x, y) = model.Pxy(x,y)  / model.Py(y);
	  model.Py_x(y, x) = model.Pxy(x,y)  / model.Px(x);
	  for z=1:model.Z
		model.Pz_xy(z, x, y) = model.Pxyz(x, y, z) * model.Pxy(x,y);
	  end
    end
  end


end
