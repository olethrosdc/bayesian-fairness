%% -*- Mode: octave -*-

%% E[u | pi, x] = \sum_{a,y} U(a, y) \pi(a | x) P(y | x)
%% D E[u | pi, x] = \sum_{a,y} U(a, y) D \pi(a | x) P(y | x)
%% d/d\theta_{xa} E[u | pi, x] = \sum_{y} U(a, y) D P(y | x) 
function [utility] = Utility(policy, model, U)
  A = rows(policy);
  X = columns(policy);
  utility_gradient = zeros(A, X);
  utility=0;
  for x=1:model.X
	for y=1:model.Y
	  for a=1:A
		EU_a = U(a, y) * model.Pxy(x,y);
		utility += EU_a * policy(a, x);
	  end
	end
  end
end
