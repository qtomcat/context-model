function [ A ] = Result( P,M )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

A(1)=not(P(1, M(1), M(2))>0.95);
A(2)=not(P(2, M(3), M(4))>0.95);

end

