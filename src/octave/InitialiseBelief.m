%% -*- Mode: octave -*-

%% In this model we basically have P(Z), P(X|Z), P(Y | X, Z)
function belief = InitialiseBelief(X, Y, Z, alpha)
  belief.Nz = alpha + zeros(Z, 1);
  belief.Nx_z = alpha + zeros(X, Z);
  belief.Ny_xz = alpha + zeros(X, Y, Z);
end
