%% -*- Mode: octave -*-
%%
%% This function returns the myopic Bayes policy for a given belief.
function bayes_policy = GetBayesPolicy(model, belief, U, lambda, alpha, n_iter, initial_policy = 0)
  A = rows(U);
  X = model{1}.X;

  n_models = length(model);
  for n=1:n_models
	model{n} = CalculateModelMarginals(model{n});
	model_delta{n} = GetModelDelta(model{n});
  endfor

  if (initial_policy) 
	bayes_policy = NormalisePolicy(initial_policy);
  else
	bayes_policy = NormalisePolicy(rand(A, X));
  end
  for iter=1:n_iter
	for n=1:n_models
	% use this gradient information to update the Bayes-optimal policy
	  [fairness_gradient] = FairnessGradient(bayes_policy, model{n}, model_delta{n});
	  [utility_gradient] = UtilityGradient(bayes_policy, model{n}, U);
	  bayes_gradient = ProjectPolicyGradient(lambda * fairness_gradient + (1 - lambda) * utility_gradient);
	  bayes_policy += alpha * bayes_gradient * belief(n);
	  bayes_policy = NormalisePolicy(bayes_policy);
	endfor
  endfor
endfunction

