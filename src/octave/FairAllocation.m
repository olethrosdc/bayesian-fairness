%% -*- Mode: octave -*-
%%
%% We examine the problem of fair allocation, when there is a measure
%%of local fairness.

n_schools = 2;
belief.n_actions = n_schools;
belief.alpha = zeros(n_schools, 1);
belief.beta = zeros(n_schools, 1);
belief.t = 0;
belief.T = 2;

for i=1:n_schools
  P_school(i) = rand;
  belief.alpha(i) = i+ 1;% rand;
  belief.beta(i) = i;%rand;
end
							%epsilon = 0.5 ; % the fairness constraint

function P = SampleBelief(belief)
  P = betarnd(belief.alpha, belief.beta);
end

function P = GetMarginal(belief)
  P = belief.alpha ./ (belief.alpha + belief.beta);
end

function P = GetMaximal(belief)
  P = GetMarginal(belief);
  P = (P==max(P));
  P /= sum(P);
end

function belief = BernoulliObserve(belief, x);
  belief.t++;
  belief.alpha += x;
  belief.beta += (1 - x);
end

%% here epsilon is the unfairness threshold we can allow
function P = OptimalFixedPolicy(belief, epsilon)
  P_marginal = GetMarginal(belief);
  P_optimal = GetMaximal(belief);
  P = epsilon * P_optimal + (1 - epsilon) * P_marginal;
end

%% here epsilon is the unfairness threshold we can allow, so we only
%% sample policies from the Dirichlet and epsilon-mix 
function P = RandomPolicy(belief, epsilon)
  P_random = SampleBelief(belief);
  P_marginal = GetMarginal(belief);
  P = epsilon * P_random + (1 - epsilon) * P_marginal;
end


function epsilon = Unfair(belief, policy)
  epsilon = norm(GetMarginal(belief) - policy, 1);
end

function V = Value(belief, policy)
  P_marginal = GetMarginal(belief);
  V = policy'*P_marginal;
end

	 %% here we have a fixed policy over next actions which we evaluate
function [F, V] = OneStepValue(belief, policy, epsilon)
  F = Unfair(belief, policy);
  V = Value(belief, policy);
  if (belief.t < belief.T)
	marginal = belief.alpha ./ (belief.alpha + belief.beta);
	Q = zeros(belief.n_actions, 1);
	ft = zeros(belief.n_actions, 1);
	for a=1:belief.n_actions
	  posterior = BernoulliObserve(belief, 1);
	  next_policy = OptimalFixedPolicy(posterior, epsilon);
	  [next_f, next_value] = OneStepValue(posterior, next_policy, epsilon);
	  ft(a) += marginal(a) * next_f;
	  Q(a) += marginal(a) * next_value;
	  
	  posterior = BernoulliObserve(belief, 0);
	  next_policy = OptimalFixedPolicy(posterior, epsilon);
	  [next_f, next_value] = OneStepValue(posterior, next_policy, epsilon);
	  ft(a) += (1 - marginal(a)) * next_f;
	  Q(a) += (1 - marginal(a)) * next_value;
	end
	F += ft' * policy;
	V += Q' * policy;
  end
end

function [F, V] = SampleValueFunction(posterior, epsilon, n_samples)
  V = -inf;
  for k=1:n_samples
	next_policy = RandomPolicy(posterior, epsilon);
	V_k = NextValue(posterior, next_policy, epsilon, n_samples);
	if (V_k > V)
	  F = Unfair(posterior, next_policy);
	  V = V_k;
	end
  end
end

function [F, V] = NextValue(belief, policy, epsilon, n_samples)
  F = Unfair(belief, policy);
  V = Value(belief, policy);
  if (belief.t < belief.T)
	marginal = belief.alpha ./ (belief.alpha + belief.beta);
	Q = zeros(belief.n_actions, 1);
	ft = zeros(belief.n_actions, 1);
	for a=1:belief.n_actions
	  posterior = BernoulliObserve(belief, 1);
	  [next_f, next_value] = SampleValueFunction(posterior, epsilon, n_samples);
	  ft(a) += marginal(a) * next_f;
	  Q(a) += marginal(a) * next_value;

	  posterior = BernoulliObserve(belief, 0);
	  [next_f, next_value] = SampleValueFunction(posterior, epsilon, n_samples);
	  ft(a) += (1 - marginal(a)) * next_f;
	  Q(a) += (1 - marginal(a)) * next_value;
	end
	F += ft' * policy;
	V += Q' * policy;
  end
end


policy = zeros(belief.n_actions, 1);
printf("One-step policy\n");
for k=1:10
  p = (k/10) * epsilon + (1 - epsilon)*0.5;
  policy(1) = p;
  policy(2) = 1 - p;
  [F, V] = OneStepValue(belief, policy, epsilon);
  printf("p:%f f:%f v:%f \n", p, F, V);
end

printf("Multi-step policy\n");
n_samples = 10;
for k=1:10
  p = (k/10) * epsilon + (1 - epsilon)*0.5;
  policy(1) = p;
  policy(2) = 1 - p;
  [F, V] = NextValue(belief, policy, epsilon, n_samples);
  printf("p:%f f:%f v:%f \n", p, F, V);
end







