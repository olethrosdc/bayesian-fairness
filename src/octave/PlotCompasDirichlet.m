
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

if (0)
    load ("10000-iter-100-steps-alpha-1.dat")


    for k=1:K
        h = figure(k);
        set (gcf(), "defaultlinelinewidth", linewidth)
        set (gcf(), "defaulttextfontsize", fontsize)

        set (gca(), "defaultlinelinewidth", linewidth)
        set (gca(), "defaulttextfontsize", fontsize)
        set (gca(), "fontsize", fontsize)
        set(h, "papersize", [320, 240]);

        semilogx(results(k).PV(:, 1), 'b-', "linewidth", 2, results(k).PV(:, 2), 'r--', "linewidth", 3);
        if (k==1 || k ==4)
            ylabel("V")
        end
        xlabel("t")
        
        if (1)
            print (["dirichlet-lambda-", lambda{k}, ".pdf"], "-S320,240", "-tight")
            print (["dirichlet-lambda-", lambda{k}, ".tikz"],  "-S320,240", "-tight")
            print (["dirichlet-lambda-", lambda{k}, ".eps"], "-S320,240", "-tight", "-color")
            matlab2tikz (["dirichlet-lambda-", lambda{k}, ".tex"], 'width', '\fwidth')
        end
    end

elseif (1)
    
    load ("compas-seq-iter-10000-period-1-samples-16-alpha-1.0.dat")
    ma = 100;
    for k=1:K
        h = figure(k);
        set (gcf(), "defaultlinelinewidth", linewidth)
        set (gcf(), "defaulttextfontsize", fontsize)

        set (gca(), "defaultlinelinewidth", linewidth)
        set (gca(), "defaulttextfontsize", fontsize)
        set (gca(), "fontsize", fontsize)
        set(h, "papersize", [320, 240]);

        semilogx(moving_average(results(k).PV(:, 1), ma), 'b-', "linewidth", 2,               moving_average(results(k).PV(:, 2), ma), 'r--', "linewidth", 3);
        if (k==1 || k ==4)
            ylabel("V")
        end
        xlabel("t")
        
        if (1)
            print (["dirichlet-lambda-seq1-", lambda{k}, ".pdf"], "-S320,240", "-tight")
            print (["dirichlet-lambda-seq1-", lambda{k}, ".tikz"],  "-S320,240", "-tight")
            print (["dirichlet-lambda-seq1-", lambda{k}, ".eps"], "-S320,240", "-tight", "-color")
            matlab2tikz (["dirichlet-lambda-seq1-", lambda{k}, ".tex"], 'width', '\fwidth')
        end
    end
else
    
    load ("compas-seq-iter-10000-period-100-samples-1-alpha-1.0.dat")


    for k=1:K
        h = figure(k);
        set (gcf(), "defaultlinelinewidth", linewidth)
        set (gcf(), "defaulttextfontsize", fontsize)

        set (gca(), "defaultlinelinewidth", linewidth)
        set (gca(), "defaulttextfontsize", fontsize)
        set (gca(), "fontsize", fontsize)
        set(h, "papersize", [320, 240]);

        semilogx(results(k).PV(:, 1), 'b-', "linewidth", 2, results(k).PV(:, 2), 'r--', "linewidth", 3);
        if (k==1 || k ==4)
            ylabel("V")
        end
        xlabel("t")
        
        if (1)
            print (["dirichlet-lambda-seq-", lambda{k}, ".pdf"], "-S320,240", "-tight")
            print (["dirichlet-lambda-seq-", lambda{k}, ".tikz"],  "-S320,240", "-tight")
            print (["dirichlet-lambda-seq-", lambda{k}, ".eps"], "-S320,240", "-tight", "-color")
            matlab2tikz (["dirichlet-lambda-seq-", lambda{k}, ".tex"], 'width', '\fwidth')
        end
    end



end
