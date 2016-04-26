function [ O ] = observation(S,A,D )
%UNTITLED4 Summary of this function goes here
%   This function returns the vector of observation depending on the position
%  of gaze and the scene configuration
d = size(S);
i = d(1); 
% number of objects
% definition of observation vector
O = repmat(-0.5 , [2, 128 128]);
% deterministic part of signal
      
O(1, S(1,1),S(1,2)) = 0.5;
O(2, S(2,1),S(2,2)) = 0.5;
%colormap('hot');
%imagesc(O);
%colorbar;
% internal noise




% generation of gaussian noise at each location
% estimation of visibility map function D


%colormap('hot');
%imagesc(V);
%colorbar;

disp('noise amplitude is estimated');
for i = 1:2
    for rx = 1:128 
      for ry = 1:128           
                % adding gaussian noise to each location, corresponding to
                % internal noise
          O(i, rx, ry)= O(i,rx, ry) +  normrnd(0, 1)/D(i, abs(rx - A(1))+1, abs(ry - A(2))+1);         
      end
    end
end
disp('observation for one object is completed');



end

