%% -*- Mode: octave -*-


if (1)
  A = 2;
  X = 8;
  Y = 2;
  Z = 2;
  
  n_models = 8;

  for n=1:n_models
	model{n} = GenerateDiscreteModel(X, Y, Z);
	model_delta{n} = GetModelDelta(model{n});
  end
  
  prior_belief = ones(n_models, 1) / n_models; % start with a uniform belief
else
  load ("simple_setup.dat");
  prior_belief = ones(n_models, 1) / n_models; % start with a uniform 
end

utility = eye(A, Y); % just try and predict Y

alpha = 0.1;
lambda = 0.5;

% 1000 iter are enough for 2x2x2x2 case3
n_iter = 10000; 
n_data = 1;

max_policies = 2;
horizon = 100;

K = 3;

PU = zeros(horizon, K, max_policies);
PV = zeros(horizon, K, max_policies);
PF = zeros(horizon, K, max_policies);

						   % the true belief only focuses on one model
true_belief = zeros(n_models, 1);
true_belief(1) = 1;

for k=1:K
  lambda(k) = (k-1)/(K - 1);
  printf("Lambda: %f\n", lambda(k));
  for policy_index = 1:max_policies
	printf("\tPolicy: %d\n", policy_index);
	belief = prior_belief;
	for time = 1:horizon
	  %printf("\t\tStep: %d\n", time);
	  fflush(stdout);
	  if (policy_index == 1) 
		policy = GetBayesPolicy(model, belief, utility, lambda(k), alpha, n_iter);
	  else					  
		policy = GetMarginalPolicy(model, belief, utility, lambda(k), alpha, n_iter);
	  endif
	  PU(time, k,policy_index) += Utility(policy, model{1}, utility);
	  PF(time, k,policy_index) += Fairness(policy, model{1}, model_delta{1});
	  PV(time, k,policy_index) += (1 - lambda(k)) * PU(time, k,policy_index) - lambda(k) * PF(time, k,policy_index);
	  if (time < horizon)
		true_model{1} = model{1};
		belief = GeneratePosteriorFromPolicy(belief, model, policy, n_data, 1);
	  end
	  %belief'
	  printf("t:%d, \tE:%f, \tU:%f, F:%f, V:%f\n", time, -belief'*log(belief), PU(time, k,policy_index), PF(time, k,policy_index), PV(time, k,policy_index));
	end
	
  end
end

for k=1:3
  figure(k)
  semilogx(PV(:, k, 1), '-;Bayes;', "linewidth", 2, PV(:, k, 2), '--;Marginal;', "linewidth", 3);
  xlabel("t")
  ylabel("V")
  print (["finite-models-lambda-", num2str(lambda(k)), ".tikz"], "-S320x240", "-tight")
  print (["finite-models-lambda-", num2str(lambda(k)), ".eps"], "-S320x240", "-tight")
  print (["finite-models-lambda-", num2str(lambda(k)), ".pdf"], "-S320x240", "-tight")
end

