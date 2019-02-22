%% -*- Mode: octave -*-

%% In this model we basically have P(Z), P(X|Z), P(Y | X, Z)
function belief = InitialiseDirichletBelief(X, Y, Z, alpha)
  belief.X = X;
  belief.Y = Y;
  belief.Z = Z;
  belief.Nx = alpha + zeros(X, 1);
  belief.Ny_x = alpha + zeros(Y, X);
  belief.Nz_yx = alpha + zeros(Z, Y, X);
end
