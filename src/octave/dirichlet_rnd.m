## -*- Mode: octave -*-
function x = dirichlet_rnd(a)
  x = gamrnd(a, 1.0);
  x /= sum(x);
  x(1) = 1 - sum(x(2:end));
end
