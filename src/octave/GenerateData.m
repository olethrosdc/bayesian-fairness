%% -*- Mode: Octave -*-
%% In this setting, we 
function [x,y,z] = GenerateData(model, policy, n_data)
  A = rows(policy);
  X = columns(policy);
  x = zeros(1, n_data);
  y = zeros(1, n_data);
  z = zeros(1, n_data);
  t = 0;
  do 
	X = discrete_rnd([1:model.X], model.Px, 1);
	a = discrete_rnd([1:A], policy(:,X), 1);
	if (a==1)
	  t++;
	  x(t) = X;
	  y(t) = discrete_rnd([1:model.Y], model.Py_x(:,x(t)), 1);
	  z(t) = discrete_rnd([1:model.Z], model.Pz_xy(:,x(t),y(t)), 1);
	endif
  until(t >= n_data)
endfunction
