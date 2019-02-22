%% -*- Mode: octave -*-
%%
%% Convergence Evaluation for a Dirichlet prior with synthetic data
%%
%%
%% A number of actions
%% X number of observations
%% Y number of classes
%% Z number of sensitive attributes
%% lambda 0: just classify 1: just be fair
%% n_iter: GD iterations
%% horizon: amount of data to generate
%%
%% PU: classification utility
%% PF: fairness deviation
%% PV: value = (1 - lambda) * PU - lambda * PF
function [PU, PF, PV] = ConvergenceEvaluationDirichlet(A=2, X=8, Y=2, Z=2, lambda=0.5, n_iter=10000, horizon=100, true_model = 0)

  %% Randomly select a model to generate data from
  if (isstruct(true_model))
	printf("Using exiting model\n"); fflush(stdout);
  else
	printf("Generating random model\n"); fflush(stdout);
	true_model = GenerateDiscreteModel(X, Y, Z);
  end
  true_model_delta = GetModelDelta(true_model);

  alpha = 0.001; % step size for GD
  dirichlet_mass = 0.5; % prior mass
  prior_belief = InitialiseDirichletBelief(X, Y, Z, dirichlet_mass);

  utility = eye(A, Y); % just try and predict Y, i.e. maximise class accuracy
  max_policies = 2; % run both Bayes and Marginal policy
  PU = zeros(horizon, max_policies);
  PV = zeros(horizon, max_policies);
  PF = zeros(horizon, max_policies);

  %% Use an arbitrary policy to generate the data from the model
  %% random_policy = NormalisePolicy(rand(A, X));
  %% Use a uniform policy to generate the data from the model
  random_policy = NormalisePolicy(ones(A, X));
  [x, y, z] = GenerateData(true_model, random_policy, horizon);

  %% main loop
  printf("Lambda: %f\n", lambda);
  for policy_index = 1:max_policies
	printf("\tPolicy: %d\n", policy_index);
	fflush(stdout); 
	belief = prior_belief; % reset the belief
	policy = random_policy;
	for time = 1:horizon
								% get the policy
	  if (policy_index == 1) 
		policy = GetBayesPolicyDirichlet(belief, utility, lambda, alpha, n_iter, policy);
	  else					  
		policy = GetMarginalPolicyDirichlet(belief, utility, lambda, alpha, n_iter, policy);
	  endif
								% save the result
	  PU(time, policy_index) += Utility(policy, true_model, utility);
	  PF(time, policy_index) += Fairness(policy, true_model, true_model_delta);
	  PV(time, policy_index) += (1 - lambda) * PU(time, policy_index) - lambda * PF(time, policy_index);
								% update the belief
	  if (time < horizon)
		belief = DirichletPosteriorBelief(belief, x(time), y(time), z(time));
	  end
	  printf("t:%d,\tU:%f, F:%f, V:%f\n", time, PU(time, policy_index), PF(time, policy_index), PV(time, policy_index));
	  fflush(stdout);
	end
  end
end
