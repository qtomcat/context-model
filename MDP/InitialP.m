function [ P ] = InitialP( Y,s )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% this function defines the initial probability of targets
P= repmat( zeros, [128 128]);
for i= 1:128
    for j= 1:128
        P(i,j)= exp( -(i-Y)*(i-Y)/(s*s));
    end;
end;
% normalization
S =0;
for i= 1:128
    for j= 1:128
        S= S + P(i,j);
    end;
end;
%result
for i= 1:128
    for j= 1:128
        P(i,j)= P(i,j)/S;
    end;
end;

end

