function [ P1 ] = InitialC( P0, P10 )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
P1 = repmat( zeros, [128 128]);
for i=1:128
    for j= 1:128
        for k=1:128
           P1(i,j)=P1(i,j)+P0(k,j)*P10(i,k);
        end;
    end;
end;
S=0;
for i= 1:128
    for j=1:128
        S= S+P1(i,j);
    end;
end;

for i= 1:128
    for j=1:128
        P1(i,j)=P1(i,j)/S;
    end;
end;
end

