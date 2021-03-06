function results = SequentialSamplingDirichletFromDataPar(options, lambda=0.5, n_iter=10000, period = 100, alpha = 0.001)
  if (options.base_name)
	filename=[options.base_name, "-lambda-", num2str(lambda), "-alpha-", num2str(alpha), "-period-", num2str(period), "-iter-", num2str(n_iter), "-samples-", num2str(options.n_samples), ".dat"];
  end
  results = SequentialSamplingDirichletFromData(options.model, options.data, options.utility, lambda, n_iter, period, alpha, options.n_samples);
  if (options.base_name)
	save (filename, "results", "options");
  end

end
