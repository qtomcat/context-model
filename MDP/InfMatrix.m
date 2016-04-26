function [ I ] = InfMatrix(I, O, A, D )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% For each the inference matrix is defined as multiplication of exponent
for l=1:2
    for i=1:128
       for j=1:128
           I(l,i,j)=I(l,i,j)*exp(O(l,i,j)*D(l, abs(i - A(1))+1, abs(j - A(2))+1)*D(l, abs(i - A(1))+1, abs(j - A(2))+1)); 
       end;
    end;
end;
end

