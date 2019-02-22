%% -*- Mode: octave -*-

%% A small test to see whether we can make a policy independent easily
%% for a given difference model.

if (0)
  A = 2;
  X = 4;
  Y = 2;
  Z = 2;

  n_models = 2;

  for n=1:n_models
	model{n} = GenerateDiscreteModel(X, Y, Z);
	model_delta{n} = GetModelDelta(model{n});
  end
else
  load ("simple_setup.dat")
endif

belief = ones(n_models, 1) / n_models; % start with a uniform belief

n_iter = 10000;
alpha = 0.1;

%% an A*X matrix describing the action probabilities
tic
bayes_policy = NormalisePolicy(rand(A, X));
for n=1:n_models
  policy{n} = NormalisePolicy(rand(A, X));
  dependence{n} = [];
  interdependence{n} = [];
end
clear bayes_dependence

for iter=1:n_iter
  for n=1:n_models

		   % get the gradient for the optimal policy of the n-th model
	[fairness_gradient, dependence{n}(iter)] = FairnessGradient(policy{n}, model{n}, model_delta{n});
	gradient{n} = ProjectPolicyGradient(fairness_gradient);
	policy{n} += alpha * gradient{n};

	% use this gradient information to update the Bayes-optimal policy
	[fairness_gradient] = FairnessGradient(bayes_policy, model{n}, model_delta{n});
	bayes_gradient = ProjectPolicyGradient(fairness_gradient);
	bayes_policy += alpha * bayes_gradient * belief(n);

	bayes_dependence(iter, n) = GetDependence(bayes_policy, model{n}, model_delta{n});

	for k=1:n_models
	  interdependence{n}(iter,k) = GetDependence(policy{n}, model{k}, model_delta{k});
	end
  end
end
toc
xaxis=[1:n_iter]';
data = [xaxis, interdependence{1}*belief,  interdependence{2}*belief, bayes_dependence*belief];
save("interdependence.dat", "data");
ma_data = moving_average(data);
semilogx(ma_data(:,1), ma_data(:,2), '--;Oracle 1;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,3), '-.;Oracle 2;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,4), '-;Bayes;', 'linewidth', 2)
matlab2tikz("interdependence.tikz");


policy
bayes_policy

