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
function results = SequentialSamplingDirichlet(A=2, X=8, Y=2, Z=2, true_model = 0, lambda=0.5, n_iter=10000, horizon=100, period = 10, alpha = 0.1, n_samples = 1)

  %% Randomly select a model to generate data from
  if (isstruct(true_model))
	printf("Using exiting model\n"); fflush(stdout);
  else
	printf("Generating random model\n"); fflush(stdout);
	true_model = GenerateDiscreteModel(X, Y, Z);
  end

  results.options.A = A;
  results.options.X = X;
  results.options.Y = Y;
  results.options.Z = Z;
  results.options.lambda = lambda;
  results.options.n_iter = n_iter;
  results.options.horizon = horizon;
  results.options.n_samples = n_samples;
  
  true_model_delta = GetModelDelta(true_model);

  dirichlet_mass = 0.5; % prior mass
  prior_belief = InitialiseDirichletBelief(X, Y, Z, dirichlet_mass);

  utility = eye(A, Y); % just try and predict Y, i.e. maximise class accuracy
  max_policies = 2; % run both Bayes and Marginal policy
  results.PU = zeros(horizon, max_policies);
  results.PV = zeros(horizon, max_policies);
  results.PF = zeros(horizon, max_policies);
  results.a  = zeros(horizon, max_policies);


  %% Use a uniform policy to generate the data from the model
  uniform_policy = NormalisePolicy(ones(A, X));
  [x, y, z] = GenerateData(true_model, uniform_policy, horizon);

  %% Use an arbitrary policy to initialise the model
  random_policy = NormalisePolicy(rand(A, X));
  %% main loop
  printf("Lambda: %f\n", lambda);

  for policy_index = 1:max_policies
	printf("\tPolicy: %d\n", policy_index);
	fflush(stdout); 
	belief = prior_belief; % reset the belief
	policy = random_policy;
	reset = period;
	for time = 1:horizon
	  if (--reset <= 0)
		reset = period;
		if (policy_index == 1) 
		  policy = GetBayesPolicyDirichlet(belief, utility, lambda, alpha, n_iter, policy, false, 0, n_samples);
		else					  
		  policy = GetMarginalPolicyDirichlet(belief, utility, lambda, alpha, n_iter, policy);
		endif
	  endif
	  
	  %% save the result
	  results.PU(time, policy_index) += Utility(policy, true_model, utility);
	  results.PF(time, policy_index) += Fairness(policy, true_model, true_model_delta);
	  results.PV(time, policy_index) += (1 - lambda) * results.PU(time, policy_index) - lambda * results.PF(time, policy_index);
	  
	  a = SelectAction(policy, x(time));

	  %% update the belief
	  a = SelectAction(policy, x(time));

	  if (time < horizon)
		%% update the belief, but only for the pieces of data we see.
		if (a==1)
		  belief = DirichletPosteriorBelief(belief, x(time), y(time), z(time));
		else
		  belief = DirichletPosteriorBelief(belief, x(time), 0, 0);
		end
	  end
	  results.a(time, policy_index) = a;
	  printf("t:%d,\tU:%f, F:%f, V:%f\n", time, results.PU(time, policy_index), results.PF(time, policy_index), results.PV(time, policy_index));
	  fflush(stdout);
	end
  end
  results.x = x;
  results.y = y;
  results.z = z;
end
