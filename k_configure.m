% Set paths and file names

homeDir = '../';

addpath([homeDir 'code/toolbox/'])
addpath([homeDir 'code/scripts/'])

dataset = 'sun09';

detectorOutputs = [homeDir 'dataset/' dataset '_detectorOutputs'];
groundTruth = [homeDir 'dataset/' dataset '_groundTruth'];
objectCategories = [homeDir 'dataset/' dataset '_objectCategories'];

HOMEIMAGES = [homeDir 'Images'];
HOMEANNOTATIONS = [homeDir 'Annotations'];

priorModel = [homeDir 'models/' dataset '_priorModel'];
priorModelIndep = [priorModel 'Indep'];
measurementModel = [homeDir 'models/' dataset '_measurementModel'];
gistPredictions = [homeDir 'models/' dataset '_gistPredictions'];

