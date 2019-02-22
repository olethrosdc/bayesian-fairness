
linewidth=3;
fontsize=12;

set (gcf(), "defaultlinelinewidth", linewidth)
set (gcf(), "defaulttextfontsize", fontsize)

set (gca(), "defaultlinelinewidth", linewidth)
set (gca(), "defaulttextfontsize", fontsize)
set (gca(), "fontsize", fontsize)

lambda = {"0.0", "0.25", "0.5", "0.75", "1.0"}

max_data = 9;
K = 5;
for i=0:max_data
  for k=1:K
	fname=["ce-dirichlet-result-long-", num2str(i), "-", lambda{k}, ".dat"]
	Data{i+1,k} = load (fname);
  end
end

for k=1:K
  PU{k} = Data{1,k}.PU; % classification utility
  PF{k} = Data{1,k}.PF; % fairness violation
  PV{k} = Data{1,k}.PV; % total value
  for i=2:(max_data+1)
	PU{k} += Data{i,k}.PU;
	PF{k} += Data{i,k}.PF;
	PV{k} += Data{i,k}.PV;
  end
end


for k=1:K
  h = figure(k);
  set (gcf(), "defaultlinelinewidth", linewidth)
  set (gcf(), "defaulttextfontsize", fontsize)

  set (gca(), "defaultlinelinewidth", linewidth)
  set (gca(), "defaulttextfontsize", fontsize)
  set (gca(), "fontsize", fontsize)
  set(h, "papersize", [320, 240]);

  semilogx(PF{k}(:, 1), '-', "linewidth", 2, PF{k}(:, 2), '--', "linewidth", 3);
  if (k==1 || k ==4)
	ylabel("V")
  end
  xlabel("t")

  if (0)
	print (["dirichlet-lambda-long-", lambda{k}, ".pdf"], "-S320,240", "-tight")
	print (["dirichlet-lambda-long-", lambda{k}, ".tikz"],  "-S320,240", "-tight")
	print (["dirichlet-lambda-long-", lambda{k}, ".eps"], "-S320,240", "-tight", "-color")
	matlab2tikz (["dirichlet-lambda-long-", lambda{k}, ".tex"], 'width', '\fwidth')
  end
end

