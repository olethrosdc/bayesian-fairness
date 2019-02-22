%% -*- Mode: octave -*-

%% This code just compacts the discrete data with many attributes so
%% that there are only three columns: outcome y, observations x,
%% sensitive variables z.

function [dp, A] = CompactDiscreteData(Data, Z_attr, X_attr, Y_attr)
  X_values = unique(Data(:, X_attr), "rows");
  Y_values = unique(Data(:, Y_attr), "rows");
  Z_values = unique(Data(:, Z_attr), "rows");
  dp.n_x = length(X_values);
  dp.n_y = length(Y_values);
  dp.n_z = length(Z_values);

  n_data = rows(Data);
  A = zeros(n_data, 3);
  for t=1:n_data
	X_indices = sum(Data(t, X_attr) == X_values, 2)==length(X_attr);
	Y_indices = sum(Data(t, Y_attr) == Y_values, 2)==length(Y_attr);
	Z_indices = sum(Data(t, Z_attr) == Z_values, 2)==length(Z_attr);
	
	A(t, 1)=[1:dp.n_y](Y_indices);
	A(t, 2)=[1:dp.n_x](X_indices);
	A(t, 3)=[1:dp.n_z](Z_indices);
  end
end
