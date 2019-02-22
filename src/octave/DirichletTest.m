%% -*- Mode: octave -*-
%%
%% Test the convergence of the belief for a Dirichlet prior with synthetic data
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
function [fit, belief, true_model] = DirichletTest(A=2, X=8, Y=2, Z=2, lambda=0.5, n_iter=10000, horizon=10000)

  %% Randomly select a model to generate data from
  true_model = GenerateDiscreteModel(X, Y, Z);
  true_model_delta = GetModelDelta(true_model);

  alpha = 0.1; % step size for GD
  dirichlet_mass = 0.5; % prior mass
  prior_belief = InitialiseDirichletBelief(X, Y, Z, dirichlet_mass);

  utility = eye(A, Y); % just try and predict Y, i.e. maximise class accuracy
  max_policies = 2; % run both Bayes and Marginal policy


  %%% Use an arbitrary policy to generate the data from the model
  %%random_policy = NormalisePolicy(rand(A, X));
  %% Use a uniform policy to generate the data from the model
  random_policy = NormalisePolicy(ones(A, X));
  [x, y, z] = GenerateData(true_model, random_policy, horizon);

  %% main loop
  printf("Lambda: %f\n", lambda);

  belief = prior_belief; % reset the belief
  
  for time = 1:horizon
	%% update the belief
  belief = DirichletPosteriorBelief(belief, x(time), y(time), z(time));
  marginal_model = CalculateMarginalModelDirichlet(belief);
  sampled_model = SampleDirichletModel(belief);
  fit(time, 1) = norm(vec(marginal_model.Pxyz - true_model.Pxyz), 1);
  fit(time, 2) = norm(vec(sampled_model.Pxyz - true_model.Pxyz), 1);
  fflush(stdout);
end

  for policy_index = 1:max_policies
	printf("\tPolicy: %d\n", policy_index);
	fflush(stdout);
	if (policy_index == 1) 
	  policy = GetBayesPolicyDirichlet(belief, utility, lambda, alpha, n_iter);
	else					  
	  policy = GetMarginalPolicyDirichlet(belief, utility, lambda, alpha, n_iter);
	end
	PU = Utility(policy, true_model, utility);
	PF = Fairness(policy, true_model, true_model_delta);
	PV = (1 - lambda) * PU - lambda * PF;
	printf("tU:%f, F:%f, V:%f\n", PU, PF, PV);
  end
end
