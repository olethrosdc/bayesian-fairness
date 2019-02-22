%% -*- Mode: octave -*-
%% The assumption here is that the dimensions are A * X, so sum(D(:,
%% x)) = 0 for all x.
%% This works most of the time, and makes the updates easier.
function D = ProjectPolicyGradient(D)
  D -= mean(D);
end
