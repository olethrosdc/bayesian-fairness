%% -*- Mode: octave -*-

linewidth=3;
fontsize=12;

set (gcf(), "defaultlinelinewidth", linewidth)
set (gcf(), "defaulttextfontsize", fontsize)

set (gca(), "defaultlinelinewidth", linewidth)
set (gca(), "defaulttextfontsize", fontsize)
set (gca(), "fontsize", fontsize)

lambda = {"0.0", "0.25", "0.5", "0.75", "1.0"}

K = 5;

load("6kdata-alpha0.1-10kiter.dat");
xaxis = moving_average([1:601]');
for k=1:K
  h = figure(k);
  set (gcf(), "defaultlinelinewidth", linewidth)
  set (gcf(), "defaulttextfontsize", fontsize)

  set (gca(), "defaultlinelinewidth", linewidth)
  set (gca(), "defaulttextfontsize", fontsize)
  set (gca(), "fontsize", fontsize)
  set(h, "papersize", [320, 240]);

  plot(xaxis, moving_average(results(k).PV(:, 1)), '-', "linewidth", 2, xaxis, moving_average(results(k).PV(:, 2)), '--', "linewidth", 3);
  ylabel("V")
  xlabel("t * 10")

  if (1)
	print (["compas-lambda-", lambda{k}, ".pdf"], "-S320,240", "-tight")
	print (["compas-lambda-", lambda{k}, ".tikz"],  "-S320,240", "-tight")
	print (["compas-lambda-", lambda{k}, ".eps"], "-S320,240", "-tight", "-color")
	xlabel("$t \times 10$")
	matlab2tikz (["compas-lambda-", lambda{k}, ".tex"], 'width', '\fwidth')
  end

  h = figure(k);
  set (gcf(), "defaultlinelinewidth", linewidth)
  set (gcf(), "defaulttextfontsize", fontsize)

  set (gca(), "defaultlinelinewidth", linewidth)
  set (gca(), "defaulttextfontsize", fontsize)
  set (gca(), "fontsize", fontsize)
  set(h, "papersize", [320, 240]);

  plot(xaxis, moving_average(results(k).PU(:, 1)), '-', "linewidth", 2, xaxis, moving_average(results(k).PU(:, 2)), '--', "linewidth", 3);
  ylabel("V")
  xlabel("t * 10")

  if (1)
	print (["compas-Ulambda-", lambda{k}, ".pdf"], "-S320,240", "-tight")
	print (["compas-Ulambda-", lambda{k}, ".tikz"],  "-S320,240", "-tight")
	print (["compas-Ulambda-", lambda{k}, ".eps"], "-S320,240", "-tight", "-color")
	xlabel("$t \times 10$")
	matlab2tikz (["compas-lambda-", lambda{k}, ".tex"], 'width', '\fwidth')
  end


  h = figure(k);
  set (gcf(), "defaultlinelinewidth", linewidth)
  set (gcf(), "defaulttextfontsize", fontsize)

  set (gca(), "defaultlinelinewidth", linewidth)
  set (gca(), "defaulttextfontsize", fontsize)
  set (gca(), "fontsize", fontsize)
  set(h, "papersize", [320, 240]);

  plot(xaxis, moving_average(results(k).PF(:, 1)), '-', "linewidth", 2, xaxis, moving_average(results(k).PF(:, 2)), '--', "linewidth", 3);
  ylabel("V")
  xlabel("t * 10")

  if (1)
	print (["compas-Flambda-", lambda{k}, ".pdf"], "-S320,240", "-tight")
	print (["compas-Flambda-", lambda{k}, ".tikz"],  "-S320,240", "-tight")
	print (["compas-Flambda-", lambda{k}, ".eps"], "-S320,240", "-tight", "-color")
	xlabel("$t \times 10$")
	matlab2tikz (["compas-lambda-", lambda{k}, ".tex"], 'width', '\fwidth')
  end

  
end

