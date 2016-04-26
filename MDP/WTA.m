function [ A, M ] = WTA( H,P )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
A = [64, 64];
[A(1),A(2)]= find(H==max(H(:)));
M = [1,1,1,1];


Pchild = repmat (zeros, [128 128]);
for rx= 1:128
    for ry=1:128
        Pchild(rx, ry)= P(1, rx, ry);
    end;
end;
        
    
Pparent= repmat (zeros, [128 128]);
for rx= 1:128
   for ry=1:128
      Pparent(rx, ry)= P(2, rx, ry);
   end;
end;

[M(1), M(2)]=find(Pchild==max(Pchild(:)));
[M(3), M(4)]=find(Pparent==max(Pparent(:)));

end

