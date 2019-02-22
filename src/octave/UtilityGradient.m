%% -*- Mode: octave -*-

%% E[u | pi, x] = \sum_{a,y} U(a, y) \pi(a | x) P(y | x)
%% D E[u | pi, x] = \sum_{a,y} U(a, y) D \pi(a | x) P(y | x)
%% d/d\theta_{xa} E[u | pi, x] = \sum_{y} U(a, y) D P(y | x)
%%
%% This gradient suffers from the same problem of going through all the x, as we want to find a decision rule that is working for all the x's.
function [utility_gradient, utility] = UtilityGradient(policy, model, U)
  A = rows(policy);
  X = columns(policy);
  utility=0;
  utility_gradient = U * model.Pxy';
## utility_gradient = zeros(A, X);
##   for x=1:model.X
## #	for y=1:model.Y
## 	  ## for a=1:A
## 	  ## 	EU_a = U(a, y) * model.Pxy(x,y);
## 	  ## 	utility_gradient(a, x) += EU_a;
## 	  ## 	% utility += EU_a * policy(a, x);
## 	  ## end
## ### First opt
## 	  ## EU_a = U(:, y) * model.Pxy(x,y);
## 	  ## utility_gradient(:, x) += EU_a;
## ### Second opt
## 	  utility_gradient(:, x) += U(:, y) * model.Pxy(x,y);
## #	end
  ##   end
  
end
