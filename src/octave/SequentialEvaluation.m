%% -*- Mode: octave -*-


if (0)
  A = 2;
  X = 2;
  Y = 2;
  Z = 2;
  
  n_models = 2;
  
  for n=1:n_models
	model{n} = GenerateDiscreteModel(X, Y, Z);
	model_delta{n} = GetModelDelta(model{n});
  end
  
  prior_belief = ones(n_models, 1) / n_models; % start with a uniform belief
else
  load ("results/simple_setup.dat");
  prior_belief = ones(n_models, 1) / n_models; % start with a uniform 
end

utility = eye(A, Y); % just try and predict Y

alpha = 0.1;
lambda = 0.5;

n_samples = 100;
n_data = 10;
max_policies = 10;
horizon = 2;
time = 1;

K = 3;

PU = zeros(K, max_policies);
PV = zeros(K, max_policies);
PF = zeros(K, max_policies);

% the true belief only focuses on one model
true_belief = zeros(n_models, 1);
true_belief(1) = 1;

%U = zeros(K, max_policies);
%V = zeros(K, max_policies);
%F = zeros(K, max_policies);
for k=1:K
  lambda(k) = (k-1)/(K - 1);
  printf("Lambda: %f\n", lambda(k));
  for n_policies = 1:max_policies
	printf("\tPolicies: %d\n", n_policies);
	belief = prior_belief;
	for time = 1:horizon
	  printf("\t\tStep: %d\n", time);
	  fflush(stdout);
	  policy = SequentialFairness(belief, model, model_delta, utility, lambda(k), n_data, n_samples, n_policies, time, horizon);
	  PU(k, n_policies) += Utility(policy, model{1}, utility);
	  PF(k, n_policies) += Fairness(policy, model{1}, model_delta{1});
	  PV(k, n_policies) += (1 - lambda(k)) * PU(k, n_policies) + lambda(k) * PF(k, n_policies);
	  if (time < horizon)
		belief = GeneratePosteriorFromPolicy(true_belief, model, policy, n_data);
	  end
	  printf("\t:%d\tU:%f, F:%f, V:%f\n", time, PU(k, n_policies), PF(k, n_policies), PV(k, n_policies));
	end
  end
end
