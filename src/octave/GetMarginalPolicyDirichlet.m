%% -*- Mode: octave -*-
%%
%% This function returns the myopic policy for the marginal model given a Dirichlet belief 
%%
%% Arguments:
%% - belief: a Dirichlet belief over the conditional probabilities
%% - U: The utility function
%% - lambda: fairness-utility trade-off
%% - n_iter: number of iterations
%% - alpha: step-size
%% - initial_policy: If initial_policy is zero then ranodmly initialise a policy. This is used to allow the algorithm to run with a specific initial policy.
%% - show_result: print the result
%% - eval_model: reference evaluation model
function [policy, results] = GetMarginalPolicyDirichlet(belief, U, lambda, alpha, n_iter, initial_policy = 0, show_result = false, eval_model = 0)
  A = rows(U);
  X = belief.X;

  marginal_model = CalculateMarginalModelDirichlet(belief);
  model_delta = GetModelDelta(marginal_model);
  if (show_result)
	eval_model_delta = GetModelDelta(eval_model);
  end
  
  if (initial_policy) 
	policy = NormalisePolicy(initial_policy);
  else
	policy = NormalisePolicy(rand(A, X));
  end

  if (show_result)
	results.PU = zeros(n_iter, 1);
	results.PF = zeros(n_iter, 1);
	results.PV = zeros(n_iter, 1);
  else
	results = {};
  end
  %% This is pure gradient descent, as there is no randomisation
  for iter=1:n_iter
	[fairness_gradient] = FairnessGradient(policy, marginal_model, model_delta);
	[utility_gradient] = UtilityGradient(policy, marginal_model, U);
	bayes_gradient = ProjectPolicyGradient(lambda * fairness_gradient + (1 - lambda) * utility_gradient);
				 %policy += (1 / (1 + alpha * iter)) * bayes_gradient;
	old_policy = policy;
	policy += alpha * bayes_gradient;
	policy = NormalisePolicy(policy);
	if (show_result)
	  results.PU(iter) += Utility(policy, eval_model, U);
	  results.PF(iter) += Fairness(policy, eval_model, eval_model_delta);
	  results.PV(iter) += (1 - lambda) * results.PU(iter) - lambda * results.PF(iter);
	  printf("t:%d,\tD:%f, P:%f, \tU:%f, F:%f, V:%f\n", iter, norm(bayes_gradient), norm(old_policy - policy), results.PU(iter), results.PF(iter), results.PV(iter));
	  fflush(stdout);
	end
  endfor
endfunction

