## -*- Mode: octave -*-
function logp = dirichlet_logpdf(a, x)
  assert((abs(sum(x)-1))<1e-9);
  z = sum(lgamma(a)) - lgamma(sum(a));
  y = log(x) .* (a-1);
  y(a==1) = 0;
  d = sum(y);
  logp = d - z;
end
