%% -*- Mode: octave -*-

pkg load parallel;

function result = test(x)
  result.x = x;
  result.y = x^2;
end

x = [1, 2];
r = pararrayfun(2, @test, x);


