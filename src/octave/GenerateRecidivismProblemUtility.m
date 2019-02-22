%% -*- Mode: octave -*-
%{

This generates a decision problem with utility $U(y, a)$ and
generative model $P(x | y)$, $P(z | x)$, but with no direct
dependence between $z, y$, so that $y \to x \to z$. In this scenario,%}
%the chance of recidivism depends on whether or not an individual has
%known criminal associates. This is a latent variable. People from
%poor backgrounds are more likely to have such associates. However,
%our model is completely agnostic about these variables.

%}

function util = GenerateRecidivismProblemUtility(violation_penalty,
												 jail_penalty)
  util = eye(2, 2); 
  util(1, 1) = 0; # released and went to trial
  util(2, 1) = -violation_penalty; # released and violated bail terms
  util(1, 2) = -jail_penalty; # not released
  util(2, 2) = -jail_penalty; # not released
end
