%% -*- Mode: octave -*-
%% Adjust policy parameters so that they are near 0. This is only a
%% very basic projection, so may not actually result in a point on the
%% simplex.
function policy = NormalisePolicy(policy)
  policy(policy<0) = 0;
  policy(policy>1) = 1;
  for x=1:columns(policy)
	policy(:,x) /= sum(policy(:,x));
  end
end
