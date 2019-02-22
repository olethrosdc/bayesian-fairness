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
function [policy V, U, F] = SequentialFairness(belief, model, model_delta, utility, lambda, n_data, n_samples, n_policies, t, T)
  n_iter = 1000; % number of gradient iterations
  alpha = 0.5; %gradient scaling
  n_models = length(model);
  V = 0;
  U = 0;
  F = 0;
  A = rows(utility);
  X = model{1}.X;
  policies{1} = GetBayesPolicy(model, belief, utility, lambda, alpha, n_iter);

  % get current utilities
  for k=1:n_models
	U += belief(k) * GetUtility(policies{1}, model{k}, utility);
	F += belief(k) * GetDependence(policies{1}, model{k}, model_delta{k});
	V += (1 - lambda) * U - lambda * F;
  end
  best_policy = 1;

  % Add next step utilities
  if (t < T)
	policies{2} = NormalisePolicy(ones(A, X));
	for k=3:n_policies
	  policies{k} = NormalisePolicy(rand(A, X));
	end
	QV = zeros(n_policies, 1);
	QU = zeros(n_policies, 1);
	QF = zeros(n_policies, 1);
	for i=1:n_policies
	  for k=1:n_samples
		[next_policy, Vk, Uk, Fk] = SequentialFairness(GeneratePosteriorFromPolicy(belief, model, policies{i}, n_data), model, model_delta, utility, lambda, n_data, n_samples, n_policies, t+1, T);
		QV(i) += Vk;
		QU(i) += Uk;
		QF(i) += Fk;
	  end
	  QV = V + QV/n_samples;
	  QU = U + QU/n_samples;
	  QF = F + QF/n_samples;
	end
	best_policy = argmax(QV);
	V = QV(best_policy);
	U = QU(best_policy);
	F = QF(best_policy);
  end
  policy = policies{best_policy};
end

