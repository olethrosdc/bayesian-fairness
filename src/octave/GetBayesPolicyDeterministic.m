%% -*- Mode: octave -*-
%%
%% This function returns the myopic Bayes policy for a given belief
%% only for the case of deterministic policies.
%%
%% While the expected utility for a given x is fixed
%% E(U|a,x) = \sum_y P(y|x) U(a,y)
%% The expected fairness is however
%% F(\pi) = \sum_{y,z} \sum_x \pi(a | x) [P(x, z | y) - P(x | y) P(z | y)]


function bayes_policy = GetBayesPolicyDeterministic(model, belief, U, lambda)
  A = rows(U);
  X = model{1}.X;
  n_models = length(model);
  for n=1:n_models
	model{n} = CalculateModelMarginals(model{n});
	model_delta{n} = GetModelDelta(model{n});
  endfor


  bayes_policy = NormalisePolicy(ones(A, X));
  V_max = -inf;
  n_policies = A^X
  for iter=1:n_policies
	policy_str = dec2base(policy, A);
	policy = zeros(A, X);
	for x=1:X
	  if (x <= length(policy_str))
		policy(:,x) = eye(A)(:, 1 + str2num(policy_str(x)));
	  else
		policy(:,x) = eye(A)(:, 1);
	  end
	end
	V = 0;
	for n=1:n_models
	  fairness = Fairness(bayes_policy, model{n}, model_delta{n});
	  utility = Utility(bayes_policy, model{n}, U);
	  V += belief(n) * ((1 - lambda) * utility - lambda * fairness);
	end
	if (V > V_max)
	  V_max = V;
	  bayes_policy = policy;
	end
  end
endfunction

