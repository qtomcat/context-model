% the application demonstrates the search task execution of observer 
homeDir = '../';
addpath([homeDir 'code/MDP/'])
% the scene state, first coordinate - x, second - y
S = [10,10; 20,40];
% visibility map for the object with detectability "area":
V= [20, 100];
D = Visibility(V);
% the initial probability of parent object - gaussian with Y mean and varianse s:
Y= 50;
S0= 100;
P0 = InitialP(Y,S0);
% the conditional probabilities for Y coordinates of child and parent
R= 10;
L= 20;
P10= Conditional(R,L);
P01= Conditional(-R,L);
% the initial probability of child
P1= InitialC(P0, P10);
% vector of first location corresponding to the center of the screen
A = [64, 64];
M = [1,1,1,1];
Xloc = A(1);
Yloc = A(2);
%inference matrix
I = repmat (1 , [2 128 128]);
P = repmat(zeros, [2 128 128]);
%saccade sequence
Z=[1,1];
while not((P(1, M(1), M(2))>0.95)&&(P(2, M(3), M(4))>0.95))
    % estimation of the observation vector - response from each location
    O = observation(S,A,D);
     % inference matrix
    I = InfMatrix(I,O,A,D);
    % inference corresponding to observation 
    P= inference(P1,P0,P10,P01,I);
    % expected entropy estimation for each location
    H= entropy(P,D,V,Z);
    %estimation of best location to transfer the gaze
    [A,M]=WTA(H,P); 
    %saving saccade sequence
    Xloc(end +1)= A(1);
    Yloc(end +1)= A(2);       
    %assessing the values of probability
    Z= Result(P,M);
end;
disp(M);
%display saccade sequence
t=0:1:(length(Xloc)-1);
figure;
plot3(Xloc,Yloc,t);





