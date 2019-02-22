## -*- Mode: octave -*-

function a = SelectAction(policy, x)
  a = discrete_rnd([1:rows(policy)], policy(:,x), 1);
end
