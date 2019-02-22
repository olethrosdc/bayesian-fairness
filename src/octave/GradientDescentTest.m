%% -*- Mode: octave -*-
%%
%% Convergence Evaluation for a Dirichlet prior with synthetic data
%%
%%
%% true_model: the model to use for evaluation
%% data: the data to use with fields data.x, data.y, data.z
%% utility: the utility matrix to use
%% lambda 0: just classify 1: just be fair
%% n_iter: GD iterations
%% period: period to do a check on
%%
%% PU: classification utility
%% PF: fairness deviation
%% PV: value = (1 - lambda) * PU - lambda * PF
function [marginal, bayes] = GradientDescentTest(eval_model, prior_belief, utility, policy_index = 2, lambda=0.5, n_iter=10000, alpha = 0.001)
  printf("Gradient Descent Test\n");
  fflush(stdout);
  X = eval_model.X;
  Y = eval_model.Y;
  Z = eval_model.Z;
  A = rows(utility);

  dirichlet_mass = 0.5; % prior mass


  PU = zeros(n_iter, 1);
  PV = zeros(n_iter, 1);
  PF = zeros(n_iter, 1);

  %% Use an arbitrary policy to generate the data from the model
  random_policy = NormalisePolicy(rand(A, X));
  %% Use a uniform policy to generate the data from the model
  %%random_policy = NormalisePolicy(ones(A, X));

  %% main loop
  printf("Lambda: %f\n", lambda);
  printf("\tPolicy: %d\n", policy_index);
  fflush(stdout); 
  belief = prior_belief; % reset the belief
  policy = random_policy;
  interval = 0;

  %% get the policy
  [marginal.policy, marginal.results] = GetMarginalPolicyDirichlet(belief, utility, lambda, alpha, n_iter, policy, true, eval_model);
  [bayes.policy, bayes.results] = GetBayesPolicyDirichlet(belief, utility, lambda, alpha, n_iter, policy, true, eval_model);

  fflush(stdout);
end

