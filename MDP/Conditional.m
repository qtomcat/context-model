function [ P12 ] = Conditional( R,S )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
P12 = repmat( zeros, [128 128]);
for i= 1:128
    for j = 1:128
        P12(i,j) = exp ( -(i-j+R)*(i-j+R)/(S*S));
    end;
end;

end

