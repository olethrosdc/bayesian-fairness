%% -*- Mode: octave -*-

%% Here we just want to generate some models

X = 3;
Y = 2;
Z = 2;
A = 3;
%% Probability models with x, y, z..

D = [q q -q; q -q q; -q q q]';

P = ones(X, A);
for x=1:X
  P(x, :) /=   sum(P(x, :));
end

alpha = 0.01;
model = 1;
for iter=1:1000
  Delta = P * D(:, model); % cost for each value of x
  for x=1:X
	for a=1:A
	  Diff(x, a) = alpha* D(x, model) * Delta(a);
	end
  end
  P += Diff;
  P(P<0) = 0;
  P(P>1) = 1;
  for x=1:X
	P(x, :) /=   sum(P(x, :));
  end
  err(iter) = norm(Delta);
end
plot(err);
