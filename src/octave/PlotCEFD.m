
linewidth=3;
fontsize=12;

set (gcf(), "defaultlinelinewidth", linewidth)
set (gcf(), "defaulttextfontsize", fontsize)

set (gca(), "defaultlinelinewidth", linewidth)
set (gca(), "defaulttextfontsize", fontsize)
set (gca(), "fontsize", fontsize)

max_data = 9
for i=0:max_data
  Data{i+1} = load (["results/cefd-result-", num2str(i), ".dat"]);
end
K = 5;

PU = Data{1}.PU; % classification utility
PF = Data{1}.PF; % fairness violation
PV = Data{1}.PV; % total value
for i=2:(max_data+1)
  PU += Data{i}.PU;
  PF += Data{i}.PF;
  PV += Data{i}.PV;
end



for k=1:K
  lambda(k) = (k-1)/(K - 1);
  h = figure(k);
  set (gcf(), "defaultlinelinewidth", linewidth)
  set (gcf(), "defaulttextfontsize", fontsize)

  set (gca(), "defaultlinelinewidth", linewidth)
  set (gca(), "defaulttextfontsize", fontsize)
  set (gca(), "fontsize", fontsize)
  set(h, "papersize", [320, 240]);

  semilogx(PV(:, k, 1), '-', "linewidth", 2, PV(:, k, 2), '--', "linewidth", 3);
  if (k==1 || k ==4)
	ylabel("V")
  end
  xlabel("t")

  if (1)
	print (["finite-models-lambda-", num2str(lambda(k)), ".pdf"], "-S320,240", "-tight")
	print (["finite-models-lambda-", num2str(lambda(k)), ".tikz"],  "-S320,240", "-tight")
	print (["finite-models-lambda-", num2str(lambda(k)), ".eps"], "-S320,240", "-tight", "-color")
	matlab2tikz (["finite-models-lambda-", num2str(lambda(k)), ".tex"], 'width', '\fwidth')
  end
end

for k=1:K
  lambda(k) = (k-1)/(K - 1);
  h = figure(k);
  set (gcf(), "defaultlinelinewidth", linewidth)
  set (gcf(), "defaulttextfontsize", fontsize)

  set (gca(), "defaultlinelinewidth", linewidth)
  set (gca(), "defaulttextfontsize", fontsize)
  set (gca(), "fontsize", fontsize)
  set(h, "papersize", [320, 240]);

  semilogx(PU(:, k, 1), '-', "linewidth", 2, PU(:, k, 2), '--', "linewidth", 3,
		   PF(:, k, 1), '-.', "linewidth", 2, PF(:, k, 2), ':', "linewidth", 3);
  if (k==1 || k ==4)
	ylabel("V")
  end
  xlabel("t")

  if (1)
	print (["finite-models-trade-lambda-", num2str(lambda(k)), ".pdf"], "-S320,240", "-tight")
	print (["finite-models-trade-lambda-", num2str(lambda(k)), ".tikz"],  "-S320,240", "-tight")
	print (["finite-models-trade-lambda-", num2str(lambda(k)), ".eps"], "-S320,240", "-tight", "-color")
	matlab2tikz (["finite-models-trade-lambda-", num2str(lambda(k)), ".tex"], 'width', '\fwidth')
  end
end

