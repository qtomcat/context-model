function [ D] = Visibility( V )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% gaussian approximation of visibility map


D= repmat ( zeros, [2 128 128]);
for i= 1:2
    for rx = 1:255
        for ry = 1:255
          D(i, rx, ry) = 0.05+10*exp(-((rx-1)*(rx-1)+ (ry-1)*(ry-1))/(2*V(i)*(1.66*1.66)));
        end
    end
end

end

