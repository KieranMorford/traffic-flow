% Greenshields
% Free flow speed 30 m/s
% Maximum Density 0.1 veh / m
 fd = LH_Greenshields(30,.1);

% making the x domain between 0 and 1000.
pbEnv = LH_general(fd,0,1000);

% Initial densities: 80 veh/km at 0<x<200m, 10 veh/km at 200<x<500m
pbEnv.setIniDens([0 200 500 1000], [40E-3 30E-3 20E-3]);

% Upstream Flows: .4 veh/s at 0<t<20s, .01 veh/s at 20<t<40s
pbEnv.setUsFlows([0 20 40 50], [.4 .3 .2]);

% Downstream flows: same
pbEnv.setDsFlows([0 20 40 50], [.4 .3 .2]);

% boundaries
X = 1000;           % Maximal x in the computational domain
nx = 500;           % Number x grid points
T = 50;             % Maximal time for the computation
nt = 500;           % Number of t grid points
dx=X/nx;            % Space step
dt=T/nt;            % Time step
xScale = 0:dx:X;    % Create vector array for spatial domain
tScale = 0:dt:T;    % Create vector array for temporal domain

% values
xValues = ones(size(tScale'))*(xScale);
tValues = tScale' * ones(size(xScale));

% solve eq
result = pbEnv.explSol(tValues,xValues);

% result{1} is the Moskowitz function 
N = result{1};

% result{2} is the active component matrix
activeComp = result{2};

% matrix of solution densities
k = pbEnv.density(tValues,xValues,activeComp);

% plots
figure
LH_plot2D(tScale, xScale, N, k, fd)