%% Uniformly generate a discrete model 

function model = GenerateDiscreteModel(X, Y, Z)
  model.X = X;
  model.Y = Y;
  model.Z = Z;
  model.Pxyz = reshape(dirichlet_rnd(ones(X*Y*Z, 1)), [X, Y, Z]);
  model = CalculateModelMarginals(model);
end
