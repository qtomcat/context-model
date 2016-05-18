function [Jprior,hprior,b,adjust] = k_loadmodel(n)

%n = 1;      % Number of the image we are processing

% Load the tree model learned from the SUN09 dataset
k_configure;

model = 'cltree';
loc = true;
gist = true;
useSamples = true;
debugmode = false;

load_tree;

% Set up some auxiliary variables

Nimages = 1;                                % We will only process one image 
DdetectorTestContext = Dtest;               % ground truth for the test set
%DdetectorTestContext = DdetectorTest;       % output of the detector test
presence_score = zeros([Ncategories, Nimages]);
presence_score_c = zeros([Ncategories, Nimages]);
presence_truth = zeros([Ncategories, Nimages]);

% Now apply the context...

% Nite = 12;      % Number of iterations
% disp('Using sampling methods for inference...')
Nite = 1;       % Number of iterations
disp('Using MAP estimates for inference...')


objects = {DdetectorTestContext(n).annotation.object.name};     % Objects detections in the image
[foo,obj] = ismember(objects, names); obj = obj';               % check for unknown detections
scores = [DdetectorTest(n).annotation.object.confidence]';

% find valid objects  % eliminate unknown detections and their scores
valid = find(obj>0);
obj = obj(valid);
scores = scores(valid);

W = length(scores); % Total number of candidate windows
prior_node_pot_g = prior_node_pot;    % prior for each possible object category

% Combine the measurement and the prior model
[adjmat, node_pot, edge_pot, pw1lscore] = addCandidateWindows(obj,scores,windowScore,prior_adjmat,prior_node_pot_g,prior_edge_pot,prob_bi1);

% Message passing order for Belief Propagation
tree_msg_order = treeMsgOrder(adjmat,root);    

% Now we will look at the location
image_size(1) = DdetectorTestContext(n).annotation.imagesize.ncols;
image_size(2) = DdetectorTestContext(n).annotation.imagesize.nrows;   
[loc_index,loc_measurements,loc_img_coords] = getWindowLoc(DdetectorTestContext(n).annotation.object(valid),names,image_size,heights);

init_node_pot = node_pot;
init_edge_pot = edge_pot;   
max_ll = -1e10;

for ite=1:1:Nite
        node_pot = init_node_pot;
        edge_pot = init_edge_pot;

    % instead of sampling from the tree, we will initialise it to the ground truth detections
    smp = ones(length(node_pot),1); % everything is off
    smp(obj) = 2;                   % turn on the observed b's
    smp(Ncategories+1:end) = 2;     % turn on the observed c's
    ll_bin = ite*1000; % For MAP estimates, always replace with new estimates.

    % Compute location statistics conditioned on the samples of binary variables.
    [Jprior,hprior] = computeJhPrior(locationPot, smp(1:Ncategories),prior_edges);
    correct_detection = (smp(Ncategories+1:end)==2);
    [Jmeas,hmeas] = computeJhMeas(loc_index(correct_detection), loc_measurements(correct_detection,:), detectionWindowLoc);

    % Compute the estimate of gi's
    map_g = (Jprior + Jmeas)\(hprior + hmeas);
    map_g = reshape(map_g',K,Ncategories)'; 
    ll_loc = 0.5*log(det(Jprior+Jmeas));
    ll = ll_bin + ll_loc;

    % Update binary potentials using location estimates
    node_pot = binPotCondLocMeas(init_node_pot,loc_index,map_g,loc_measurements,detectionWindowLoc); % Compute p(cik | bi, Li, Wik)
    edge_pot = binPotCondLoc(init_edge_pot,locationPot,prior_edges,map_g); % Compute p(bj | bi, Li, Lj)

    if(ll > max_ll)
        max_ll = ll;
        max_node_pot = node_pot;
        max_edge_pot = edge_pot;
    end                        
    
end

b = smp(1:Ncategories);

node_pot = max_node_pot;
edge_pot = max_edge_pot;

node_marginals = sumProductBin(adjmat, node_pot, edge_pot, tree_msg_order);
new_scores = node_marginals(:,2);   

adjust = heights;
