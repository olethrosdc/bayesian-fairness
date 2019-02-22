%% -*- Mode: octave -*-
%%
%% Convergence Evaluation for a Dirichlet prior with synthetic data
%%
%%
%% true_model: the model to use for evaluation
%% data: the data to use with fields data.x, data.y, data.z
%% utility: the utility matrix to use
%% lambda 0: just classify 1: just be fair
%% n_iter: GD iterations
%% period: period to do a check on
%%
%% PU: classification utility
%% PF: fairness deviation
%% PV: value = (1 - lambda) * PU - lambda * PF
function results = ConvergenceEvaluationDirichletFromData(true_model, data, utility, lambda=0.5, n_iter=10000, period = 100, alpha = 0.001, n_samples = 16)
  X = true_model.X;
  Y = true_model.Y;
  Z = true_model.Z;
  A = rows(utility);
  horizon = length(data.x);
  n_iter
  period
  true_model_delta = GetModelDelta(true_model);
  alpha
  period
  n_iter
  
  dirichlet_mass = 0.5; % prior mass
  prior_belief = InitialiseDirichletBelief(X, Y, Z, dirichlet_mass);

  %utility = eye(A, Y); % just try and predict Y, i.e. maximise class accuracy
  max_policies = 2; % run both Bayes and Marginal policy
  n_intervals = 1 + ceil(horizon / period);
  results.PU = zeros(n_intervals, max_policies);
  results.PV = zeros(n_intervals, max_policies);
  results.PF = zeros(n_intervals, max_policies);

  %% Use an arbitrary policy to start off
  random_policy = NormalisePolicy(rand(A, X));

  %% main loop
  printf("Lambda: %f\n", lambda);
  for policy_index = 1:max_policies
	printf("\tPolicy: %d\n", policy_index);
	fflush(stdout); 
	belief = prior_belief; % reset the belief
	policy = random_policy;
	interval = 0;
	period_left = 1;
	for time = 1:horizon
	  if (--period_left <= 0 || time == horizon)
		period_left = period;
		interval++;
		%% get the policy
		if (policy_index == 1) 
		  policy = GetBayesPolicyDirichlet(belief, utility, lambda, alpha, n_iter, policy);
		else					  
		  policy = GetMarginalPolicyDirichlet(belief, utility, lambda, alpha, n_iter, policy);
		endif
		
		%% save the result
		
		results.PU(interval, policy_index) += Utility(policy, true_model, utility);
		results.PF(interval, policy_index) += Fairness(policy, true_model, true_model_delta);
		results.PV(interval, policy_index) += (1 - lambda) * results.PU(interval, policy_index) - lambda * results.PF(interval, policy_index);
		results.Entropy(interval, policy_index) = PolicyEntropy(policy);
		%results.Error(interval) = ModelError(belief, true_model);
		printf("t:%d,\tU:%f, F:%f, V:%f, H:%f, E:\n", time, results.PU(interval, policy_index), results.PF(interval, policy_index), results.PV(interval, policy_index), results.Entropy(interval, policy_index));#, results.Error(interval));
		fflush(stdout);
	  end

	  % update the belief
	  belief = DirichletPosteriorBelief(belief, data.x(time), data.y(time), data.z(time));
	end
  end
end
