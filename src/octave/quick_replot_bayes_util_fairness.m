figure(1);
xaxis=[1:n_iter]';
data = [xaxis, interdependence{1}*belief,  interdependence{2}*belief, bayes_dependence*belief];
save("interdependence.dat", "data");
ma_data = moving_average(data);
semilogx(ma_data(:,1), ma_data(:,2), '--;Oracle 1;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,3), '-.;Oracle 2;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,4), '-;Bayes;', 'linewidth', 2)
matlab2tikz("interdependence.tikz", "width", "0.45\textwidth");

figure(2);
xaxis=[1:n_iter]';
data = [xaxis, utility*belief,  interutility{2}*belief, bayes_utility*belief];
save("interutility.dat", "data");
ma_data = moving_average(data);
semilogx(ma_data(:,1), ma_data(:,2), '--;Oracle 1;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,3), '-.;Oracle 2;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,4), '-;Bayes;', 'linewidth', 2)
matlab2tikz("interutility.tikz", "width", "0.45\textwidth");

figure(3);
xaxis=[1:n_iter]';
data = [xaxis, -lambda * interdependence{1}*belief + (1 - lambda) * interutility{2}*belief, -lambda * interdependence{2}*belief + (1 - lambda) * interutility{2}*belief, -lambda * bayes_dependence*belief + (1 - lambda) * bayes_utility*belief];

save("mixed_util_dep.dat", "data");
ma_data = moving_average(data);
semilogx(ma_data(:,1), ma_data(:,2), '--;Oracle 1;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,3), '-.;Oracle 2;', 'linewidth', 3,
		 ma_data(:,1), ma_data(:,4), '-;Bayes;', 'linewidth', 2)
matlab2tikz("mixed_util_dep.tikz", "width", "0.45\textwidth");

policy
bayes_policy

