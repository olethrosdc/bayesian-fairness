## -*- Mode: octave -*-
n_runs = 10;

for k=1:5
  PV{k} = zeros(1000, 2);
  for j=1:n_runs
	R{j}=load (["seq-random-10000-iter-1000-steps-16-samples-1.0-alpha-run-", num2str(j),".dat"]);
	PV{k} += R{j}.results(k).PV;
  end
  PV{k} /= n_runs;
  figure(k);
  %plot(moving_average(PV{k}));
  plot(cumsum(PV{k})./[1:1000]');
endfor

