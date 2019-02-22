%% -*- Mode: octave -*-

%% A small test to see whether we can make a policy independent easily
%% for a given difference model.
%% Here we also add utilities.

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
  
  belief = ones(n_models, 1) / n_models; % start with a uniform belief
else
  load ("simple_setup.dat");
end

U = eye(A, Y); % just try and predict Y

n_iter = 10000;
alpha = 0.1;

%% an A*X matrix describing the action probabilities

bayes_policy = NormalisePolicy(rand(A, X));
for n=1:n_models
  policy{n} = NormalisePolicy(rand(A, X));
  dependence{n} = [];
  interdependence{n} = [];
end
clear bayes_dependence

lambda = 0.5;
tic
for iter=1:n_iter
  for n=1:n_models

		   % get the gradient for the optimal policy of the n-th model
	[fairness_gradient, dependence{n}(iter)] = FairnessGradient(policy{n}, model{n}, model_delta{n});
	[utility_gradient, utility(iter, n)] = UtilityGradient(policy{n}, model{n}, U);
	gradient{n} = ProjectPolicyGradient(lambda * fairness_gradient + (1 - lambda)* utility_gradient);
	policy{n} += alpha * gradient{n};
	policy{n} = NormalisePolicy(policy{n});
% use this gradient information to update the Bayes-optimal policy
	[fairness_gradient] = FairnessGradient(bayes_policy, model{n}, model_delta{n});
	[utility_gradient] = UtilityGradient(bayes_policy, model{n}, U);
	bayes_gradient = ProjectPolicyGradient(lambda * fairness_gradient + (1 - lambda) * utility_gradient);
	bayes_policy += alpha * bayes_gradient * belief(n);
	bayes_policy = NormalisePolicy(bayes_policy);
	bayes_dependence(iter, n) = GetDependence(bayes_policy, model{n}, model_delta{n});
	bayes_utility(iter, n) = GetUtility(bayes_policy, model{n}, U);
	for k=1:n_models
	  interdependence{n}(iter,k) = GetDependence(policy{n}, model{k}, model_delta{k});
	  interutility{n}(iter,k) = GetUtility(policy{n}, model{k}, U);
	end
  end
end
toc

figure(1);
xaxis=[1:n_iter]';
data = [xaxis, interdependence{1}*belief,  interdependence{2}*belief, bayes_dependence*belief];
save("interdependence.dat", "data");
ma_data = moving_average(data);
semilogx(ma_data(:,1), ma_data(:,2), '--;Oracle 1;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,3), '-.;Oracle 2;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,4), '-;Bayes;', 'linewidth', 2)
matlab2tikz("interdependence.tikz", "showinfo", false, "width", "0.45\\textwidth");

figure(2);
xaxis=[1:n_iter]';
data = [xaxis, utility*belief,  interutility{2}*belief, bayes_utility*belief];
save("interutility.dat", "data");
ma_data = moving_average(data);
semilogx(ma_data(:,1), ma_data(:,2), '--;Oracle 1;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,3), '-.;Oracle 2;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,4), '-;Bayes;', 'linewidth', 2)
matlab2tikz("interutility.tikz", "showinfo", false, "width", "0.45\\textwidth");

figure(3);
xaxis=[1:n_iter]';
data = [xaxis, -lambda * interdependence{1}*belief + (1 - lambda) * interutility{2}*belief, -lambda * interdependence{2}*belief + (1 - lambda) * interutility{2}*belief, -lambda * bayes_dependence*belief + (1 - lambda) * bayes_utility*belief];

save("mixed_util_dep.dat", "data");
ma_data = moving_average(data);
semilogx(ma_data(:,1), ma_data(:,2), '--;Oracle 1;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,3), '-.;Oracle 2;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,4), '-;Bayes;', 'linewidth', 2)
matlab2tikz("mixed_util_dep.tikz", "showinfo", false, "width", "0.45\\textwidth");

