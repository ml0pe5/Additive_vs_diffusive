function params = set_paras(n,coup, kmax)
% set parameters for the simulation of a network of hopf normal form
% coup = coupling and can be
%   all: all to all connected
%   chain: unidirectional chain
%   dis: fully disconnected

% parameters in the system
params.alpha = 0.05;                   % noise amplitude
params.lambda = 0.8;                   % excitability 
params.nu = 1-params.lambda;                  % nu = 0.2
params.omega = 0;                      % Frequency

% parameters for the simulations
params.h = 1e-3;                       % time step
params.kmax = kmax;                    % max number of realisations for each beta
params.thresh = 0.5;                   % escape threshold

% for the coupling
params.beta = [0, logspace(-3,0,40)]; 
params.gamma = [0, logspace(-3,0,40)];  

if isequal(coup,'all')
    A = ones(n,n) - eye(n,n);
elseif isequal(coup,'chain') % chain or ring coupling
    A = zeros(n,n);
    A(1,2) = 1; % 2 node only!

elseif isequal(coup,'dis')
    A = zeros(n,n);
end

% expand to k realisations all at once
I = eye(kmax);
Aext = kron(I,A); % repeat on the diag
Aext = sparse(Aext);

params.A = A;
params.Aext = Aext;


