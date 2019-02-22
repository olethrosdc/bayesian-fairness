%% -*- Mode: octave -*-
%%
%% This fairness gradient uses the model delta, which is essentially
%% P(x | y, z) - P(x | y)
%% For the case where X is not finite, we can either (a) use a stochastic update or (b) only use the actual observed x, thus turning it back into a finite set.
function [fairness_gradient, dependence] = FairnessGradient(policy, model, model_delta)
  A = rows(policy);
  X = columns(policy);
  dependence = 0;
%%% Completely vectorised implementation - somehow works
  fairness_gradient = - policy * model_delta * model_delta';
## fairness_gradient = zeros(A, X);
##   for y=1:model.Y
## 	for z=1:model.Z
## %%% second simpliciation
## 	  %%fairness_gradient -= policy * model_delta(:, y, z) * model_delta(:, y, z)';
## %%% first simplification
## 	  %delta = policy * model_delta(:, y, z);
## 	  %fairness_gradient -= delta * model_delta(:, y, z)';
## %% Original loop
## 	  %%for x=1:model.X
## 	  %% 	for a=1:A
## 	  %% 	  fairness_gradient(a, x) -= delta(a) * model_delta(x, y, z);
## 	  %% end
## 	  %%  end
## 	  %% dependence += norm(delta, 1);
## 	end
##   end

end
