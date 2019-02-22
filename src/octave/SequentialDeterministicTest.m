%% -*- Mode: octave -*-

%% A small test to see whether we can make a policy independent easily
%% for a given difference model.
%% Here we also add utilities.

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
  
  belief = ones(n_models, 1) / n_models; % start with a uniform belief
else
  load ("simple_setup.dat");
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

for n_policies = 1:max_policies
  U = zeros(K,1);
  V = zeros(K,1);
  F = zeros(K,1);
  for k=1:K
	lambda(k) = (k-1)/(K - 1);
	[policy, V(k), U(k), F(k)] = SequentialFairnessDeterministic(belief, model, model_delta, utility, lambda(k), n_data, n_samples, time, horizon);
  end
  
  plot(lambda, U, ';U;', lambda, V, ';V;', lambda, F, ';F;')
  PU(:, n_policies) = U;
  PV(:, n_policies) = V;
  PF(:, n_policies) = F;
end
