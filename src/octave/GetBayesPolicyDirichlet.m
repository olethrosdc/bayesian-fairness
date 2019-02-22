%% -*- Mode: octave -*-
%%
%% This function returns the myopic Bayes policy for a given dirichlet belief.
%% belief: the dirichlet belief
%% U: the utility matrix
%% lambda:- 0-> maximise U, 1->minimise F
%% alpha: step size
%% n_iter: number of gradient iterations
%% initial_policy: if present, use it as a starting point for GD
function [bayes_policy, results] = GetBayesPolicyDirichlet(belief, U, lambda, alpha, n_iter, initial_policy = 0, show_result = false, eval_model = 0, n_models = 16)
  A = rows(U);
  X = belief.X;

  if (show_result)
	eval_model_delta = GetModelDelta(eval_model);
  end



  if (initial_policy) 
	bayes_policy = NormalisePolicy(initial_policy);
  else
	bayes_policy = NormalisePolicy(rand(A, X));
  end

  if (show_result)
	results.PU = zeros(n_iter, 1);
	results.PF = zeros(n_iter, 1);
	results.PV = zeros(n_iter, 1);
  else
	results = {};
  end

	
  %% this is effectively SGD, as we move in a random direction each time
  %% Do mini-batches over the models
  %%n_models = 16;

  resample_interval = ceil((n_iter));
  resample = 0;
  M = 0;
  for iter=1:n_iter
	if (--resample <= 0)
	  for n=1:n_models;
  		model{n} = SampleDirichletModel(belief);
		model_delta{n} = GetModelDelta(model{n});
	  end	
	  resample = resample_interval;
	end
	M = mod(M, n_models) + 1;
	% use this gradient information to update the Bayes-optimal policy
	[fairness_gradient] = FairnessGradient(bayes_policy, model{M}, model_delta{M});
	[utility_gradient] = UtilityGradient(bayes_policy, model{M}, U);
	bayes_gradient = ProjectPolicyGradient(lambda * fairness_gradient + (1 - lambda) * utility_gradient);
	old_bayes_policy = bayes_policy;
	bayes_policy += alpha * bayes_gradient;
	bayes_policy = NormalisePolicy(bayes_policy);
	if (show_result)
	  results.PU(iter) += Utility(bayes_policy, eval_model, U);
	  results.PF(iter) += Fairness(bayes_policy, eval_model, eval_model_delta);
	  results.PV(iter) += (1 - lambda) * results.PU(iter) - lambda * results.PF(iter);
	  printf("t:%d,\tD:%f, P:%f, \tU:%f, F:%f, V:%f\n", iter, norm(bayes_gradient), norm(old_bayes_policy - bayes_policy), results.PU(iter), results.PF(iter), results.PV(iter));
	  fflush(stdout);
	end

  endfor
endfunction

