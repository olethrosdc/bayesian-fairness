* Main code:

compas_convergence_test.m : test convergence on the COMPAS data
marginal_vs_credible_compas.m: run the paper's main experiment with COMPAS data
marginal_vs_credible_compas_sequential.m: run the paper's sequential experiment with COMPAS data
policy_stochasticity.m: a simple experiment to quickly measure policy stochasticity

* Subroutines:

GetBayesPolicy: Get the Bayes-optimal stationary policy when there is a finite number of models
GetBayesPolicyDirichlet: Get the Bayes-optimal stationary policy when the distribution of parameters is Dirichlet
GetMarginalPolicy: Get the optimal policy for the average (marginal) model from a belief over a fintie number of model
UtilityGradient: Get the utility gradient for a finite-observation-space model
FairnessGradient: Get the fairness gradient for a finite-observation-space model
Utility: Get the utility for a finite-observation-space model
Fairness: Get the fairness for a finite-observation-space model
