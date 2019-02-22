%% -*- Mode: octave -*-
%% 
%% @argument policy: AxX matrix where A is the number of actions and X the number of observations
function H = PolicyEntropy(policy)
  H = 0;
  for x=1:columns(policy)
	for a=1:rows(policy);
	  if (policy(:,x))
		H += policy(:,x)' * log(policy(:,x));
	  end
	end
  end
  H /= columns(policy);
end
