## -*- Mode: octave -*-
## dirichlet_pdf (a, x)
## a: parameters
## x: point in iso
function p = dirichlet_pdf (a, x)
  p = exp(dirichlet_logpdf(a, x));
end
