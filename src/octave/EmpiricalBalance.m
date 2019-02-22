%% -*- Mode: octave -*-

%%% Calculate the balance deviation from data
%%% F(a,y,z) = \sum_x \pi(a | x) [P(x | y) - P(x | y, z)]
%%% \sum_x P(x) \pi(a | x) [P(y | x)  / P(y) - P(y, z | x) / P(y,z)]
function B = EmpiricalBalance(model, x, y, z, a)
  T = length(x)
  B = zeros(max(a), model.Y, model.Z);
  N = zeros(max(a), model.Y, model.Z);
  for t=1:T
	N(a(t), y(t), z(t))++;
	B(a(t), y(t), z(t)) += model.Py_x(y(t), x(t)) / model.Py(y(t)) - model.Py_x(y(t), x(t)) * model.Pz_xy(z(t), x(t), y(t)) / model.Pyz(y(t), z(t));
  end
  B ./= N;
end
