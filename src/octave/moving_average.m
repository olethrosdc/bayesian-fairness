## Copyright (C) 2004 Christos Dimitrakakis -*- Mode: octave -*-
##
## This program is free software. You can redistribute it and/or
## modify it under the terms of the GNU General Public
## License as published by the Free Software Foundation;
## either version 2, or (at your option) any later version.

## moving_average: get a K-step moving average of a vector series
## 
## usage: [y,z]=moving_average (x, K)
##
## Return the moving average of a series
##
## x is the series data in matrix form, each series being a vector
## K is the number of points to average
##
## z is the series of averaged indices
## y is the series of averaged points
##
##
## Author: Christos Dimitrakakis <dimitrak@idiap.ch>

function [y,z]=moving_average (x, K=ceil(length(x).^(1/3)))
  a = floor(K);
  assert (a>0);
  N = length(x);
  K = length(x)/a;
  y=zeros(K,columns(x));
  z=zeros(K,1);
  zi = 0;
  R=[1:a];
  for i=1:K
    y(i,:)=mean(x(R,:));

    z(i)=mean(R);
    R+=a;
  end

