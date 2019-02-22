%% -*- Mode: octave -*-

%% In this model we basically have P(Z), P(X|Z), P(Y | X, Z)
%% Missing data is noted by 0.
function belief = DirichletPosteriorBelief(belief, x, y, z)
  for t=1:rows(x)
	belief.Nx(x(t))++;
	if (y(t))
	  belief.Ny_x(y(t), x(t))++;
	  if (z(t))
		belief.Nz_yx(z(t), y(t), x(t))++;
	  end
	end
  end
end
