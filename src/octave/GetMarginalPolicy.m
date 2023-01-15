%% -*- Mode: octave -*-
%%
%% This function returns the myopic policy for the marginal model given a belief.
%% Arguments:
%% - model: a finite collection of models of the conditional probabilities of the variables x,y,z
%% - belief: a finite vector of probabilities, one for each model
%% - U: The utility function
%% - lambda: fairness-utility trade-off
%% - alpha: step-size
%% - initial_policy: If initial_policy is zero then ranodmly initialise a policy. This is used to allow the algorithm to run with a specific initial policy.
function policy = GetMarginalPolicy(model, belief, U, lambda, alpha, n_iter, initial_policy = 0)
  A = rows(U);
  X = model{1}.X;

  marginal_model = CalculateMarginalModel(model, belief);
  model_delta = GetModelDelta(marginal_model);
  
  if (initial_policy) 
	policy = NormalisePolicy(initial_policy);
  else
	policy = NormalisePolicy(rand(A, X));
  end
  ## Calculate the gradient for the average model
  for iter=1:n_iter
	[fairness_gradient] = FairnessGradient(policy, marginal_model, model_delta);
	[utility_gradient] = UtilityGradient(policy, marginal_model, U);
	bayes_gradient = ProjectPolicyGradient(lambda * fairness_gradient + (1 - lambda) * utility_gradient);
	policy += alpha * bayes_gradient;
	policy = NormalisePolicy(policy);
  endfor
endfunction

