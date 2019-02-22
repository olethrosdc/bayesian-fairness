%% -*- Mode: octave -*-

function results = ConvergenceEvaluationDirichletFromDataPar(options, lambda=0.5, n_iter=10000, period = 100, alpha = 0.001)
  if (options.base_name)
	filename=[options.base_name, "-lambda-", num2str(lambda), "-alpha-", num2str(alpha), "-period-", num2str(period), "-iter-", num2str(n_iter), ".dat"];
  end
  results = ConvergenceEvaluationDirichletFromData(options.model, options.data, options.utility, lambda, n_iter, period, alpha);
  if (options.base_name)
	save (filename, "results", "options");
  end
end
