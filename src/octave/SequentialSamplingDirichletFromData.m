%% -*- Mode: octave -*-
%%
%% Sequential sampling for a Dirichlet prior from a dataset
%% In this setting, action 1 observes the data, action 2 does not.
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
function results = SequentialSamplingDirichletFromData(true_model, data, utility, lambda=0.5, n_iter=10000, period = 100, alpha = 0.001, n_samples = 1)
  X = true_model.X;
  Y = true_model.Y;
  Z = true_model.Z;
  A = rows(utility);
  horizon = rows(data.x);
  
  true_model_delta = GetModelDelta(true_model);

  dirichlet_mass = 0.5; % prior mass
  prior_belief = InitialiseDirichletBelief(X, Y, Z, dirichlet_mass);

  %utility = eye(A, Y); % just try and predict Y, i.e. maximise class accuracy
  max_policies = 2; % run both Bayes and Marginal policy
  n_intervals = 1 + ceil(horizon / period);
  results.PU = zeros(n_intervals, max_policies);
  results.PV = zeros(n_intervals, max_policies);
  results.PF = zeros(n_intervals, max_policies);

  %% Use an arbitrary policy to generate the data from the model
   random_policy = NormalisePolicy(rand(A, X));
  %% Use a uniform policy to generate the data from the model
   uniform_policy = NormalisePolicy(ones(A, X));
  [x, y, z] = GenerateData(true_model, uniform_policy, horizon);

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
		  policy = GetBayesPolicyDirichlet(belief, utility, lambda, alpha, n_iter, policy, false, 0, n_samples);
		else					  
		  policy = GetMarginalPolicyDirichlet(belief, utility, lambda, alpha, n_iter, policy);
		endif
		
		%% save the result
		
		results.PU(interval, policy_index) += Utility(policy, true_model, utility);
		results.PF(interval, policy_index) += Fairness(policy, true_model, true_model_delta);
		results.PV(interval, policy_index) += (1 - lambda) * results.PU(interval, policy_index) - lambda * results.PF(interval, policy_index);
		printf("t:%d,\tU:%f, F:%f, V:%f\n", time, results.PU(interval, policy_index), results.PF(interval, policy_index), results.PV(interval, policy_index));
		fflush(stdout);
	  end
	  
	  a = SelectAction(policy, data.x(time));

	  %% update the belief, but only for the pieces of data we see.
	  if (a==1)
		belief = DirichletPosteriorBelief(belief, data.x(time), data.y(time), data.z(time));
	  else
		belief = DirichletPosteriorBelief(belief, data.x(time), 0, 0);
	  end
	end
  end
end
