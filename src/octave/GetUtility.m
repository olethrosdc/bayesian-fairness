%% -*- Mode: octave -*-

function [utility] = GetUtility(policy, model, U)
  A = rows(policy);
  X = columns(policy);
  utility = 0;
  for x=1:model.X
	for y=1:model.Y
	  	for a=1:A
		  utility += policy(a, x) * model.Py_x(y, x) * U(a, y) * model.Px(x);
		end
	end
  end
end
