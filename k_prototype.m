% Set up the paths to the images and scripts
clear all;

% Load the tree model learned from the SUN09 dataset
NImage = 1;
[Jprior,hprior,b,heights] = k_loadmodel(NImage);

% Calculate the covariance form for easier marginalisation
Sigma = inv(Jprior);
mu = Sigma * hprior;

% Marginal probability of node D
Dindex    = [103]';      % Node number
DvaluePix = [3.5]';     % value of that node in pixel coordinates
DsizePix  = [10]';      % size of the object in pixels
Dvalue = DvaluePix ./ DsizePix .* heights(Dindex);  % location in world coordinates

Dindex = Dindex*2 - 1;   % We always have a Y coord followed by a logZ coord, so multiply by 2
mu1 = mu(Dindex);
Sigma11 = Sigma(Dindex,Dindex);

NormFactor = 1 / ( (2*pi)^(length(Dindex)/2) * det(Sigma11)^(1/2) );
MarProb = NormFactor * exp(-0.5*(Dvalue-mu1)' * inv(Sigma11) * (Dvalue-mu1) )
%MarProb = 1/(sqrt(Sigma(D,D))*sqrt(2*pi)) * exp((-(valD-mu(D))^2)/(2*Sigma(D,D)))


% Conditional probability of A given B
Aindex = [3 5 7]';       % Node indices
AvaluePix = [2.1 3.2 1]';   % Node values in pixel coordinates
AsizePix  = [10 10 10]';    % size of the objexts in pixels
Avalue = AvaluePix ./ AsizePix .* heights(Aindex);  % location in world coordinates
Aindex = Aindex*2 - 1;   % We always have a Y coord followed by a logZ coord, so multiply by 2

Bindex = [11 17]';       % Node indices
BvaluePix = [2 3]';         % Node values in pixel coordinates
BsizePix  = [10 10]';    % size of the objexts in pixels
Bvalue = BvaluePix ./ BsizePix .* heights(Bindex);  % location in world coordinates
Bindex = Bindex*2 - 1;   % We always have a Y coord followed by a logZ coord, so multiply by 2

J11 = Jprior(Aindex,Aindex);
J12 = Jprior(Aindex,Bindex);
J21 = Jprior(Bindex,Aindex);
J22 = Jprior(Bindex,Bindex);

h1 = hprior(Aindex);

% p(A|B) where A and B are vectors representing nodes in Aindex and Bindex
NormFactor = 1 / ( (2*pi)^(length(Aindex)/2) * det(inv(J11))^(1/2) );
condProb = NormFactor * exp(-0.5*Avalue'*J11*Avalue + (h1 - J12*Bvalue)'*Avalue)
