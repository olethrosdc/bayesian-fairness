%% -*- Mode: octave -*-
%% n_samples: the number of samples taken
%% n_policies: the number of policies to explore
%% --- The first policy is always the optimal myopic policy
%% --- The second policy is always uniformly random
%% --- The remaining policies are randomly selected
%%
%% Returns
%% V = (1 - lambda) * U + lambda * F;
%% U: utility
%% F: fairness violation
function [bayes_policy, V, U, F] = SequentialFairnessDeterministic(belief, model, model_delta, utility, lambda, n_data, n_samples, step, horizon)
  n_models = length(model);
  V = 0;
  U = 0;
  F = 0;
  A = rows(utility);
  X = model{1}.X;

  %%  printf("Entering function\n"); fflush(stdout);
  bayes_policy = NormalisePolicy(ones(A, X));
  V_max = -inf;

  % exclude the last policy which admits nobody
  n_policies = A^X - 1;
  for iter=1:n_policies
	%%printf("policy: %d/%d\n", iter, n_policies); fflush(stdout);
	%% generate policy
	policy_str = dec2base(iter - 1, A);
	for x=1:X
	  if (x <= length(policy_str))
		policy(:,x) = eye(A)(:, 1 + str2num(policy_str(x)));
	  else
		policy(:,x) = eye(A)(:, 1);
	  end
	end
		
	%% Get local value
	Vt = 0;
	Ut = 0;
	Ft = 0;
	for n=1:n_models
	  Ut += belief(n) * GetUtility(policy, model{n}, utility);
	  Ft += belief(n) * GetDependence(policy, model{n}, model_delta{n});
	  Vt += (1 - lambda) * U - lambda * F;
	end

	%% add future value
	QV = 0;
	QU = 0;
	QF = 0;
	if (step < horizon)
	  %%printf ("\tt: %d %d\n", t, horizon); fflush(stdout);
	  for k=1:n_samples
		%%printf ("\t\tk: %d/%d\n", k, n_samples); fflush(stdout);
		[next_policy, Vk, Uk, Fk] = SequentialFairnessDeterministic(GeneratePosteriorFromPolicy(belief, model, policy, n_data), model, model_delta, utility, lambda, n_data, n_samples, step + 1, horizon);
		QV += Vk;
		QU += Uk;
		QF += Fk;
	  end
	  Vt += QV/n_samples;
	  Ut += QU/n_samples;
	  Ft += QF/n_samples;
	end
	
	if (V_max < Vt)
	  V_max = Vt;
	  V = V_max;
	  U = Ut;
	  F = Ft;
	  bayes_policy = policy;
	end

  end
  %%printf("Exiting\n"); fflush(stdout);
end

