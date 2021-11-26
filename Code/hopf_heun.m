%% stochastic simulation of Hopf model - Stochastic Heun method
% computing realisations and monitoring the escape time
% 2-nodes, bidirectional, additive and diffusive coupling
%
% Jennifer Creaser July 2021


n = 2; % number of nodes in network
coup = 'all';

kmax = 2000;    % how many to compute at once
k = kmax*n;
% set parameters for type of network (all, chain, dis)
paras = set_paras(n, coup,kmax);

% node function - subcritical hopf
nodeFunc = @(y,beta,gamma,paras) (-paras.nu + 1i*paras.omega).*y + 2.*y.*(abs(y).^2) - y.*(abs(y).^4);

% coupling function - both

B = sum( paras.Aext, 2 );     % coupling strength and structure fixed for each beta
coupFunc = @(y,beta,gamma,B) (gamma + beta)*(paras.Aext)*y - beta*B.*y; 

rmax = 100000;

%% compute realisations

for j = 1:length(paras.beta)  %1:length(paras.beta)                    % find mean escape time for each beta valu
    beta = paras.beta(j);
    
    for g = length(paras.gamma):-1:1                    % find mean escape time for each beta valu
        gamma = paras.gamma(g);
        
        % set up noise vals - this takes time
        myrands1 = paras.alpha .* sqrt(paras.h) .* (randn(k,rmax) + sqrt(-1).*randn(k,rmax));
        myrands2 = paras.alpha .* sqrt(paras.h) .* (randn(k,rmax) + sqrt(-1).*randn(k,rmax));
        r=1;
        
        y = zeros(k,1);                 % initial value
        t = 0;                          % initial time
        
        tau = zeros(1,k);            % time placeholder
        X = zeros(1,k);              % initial state
        
        while 1                 % no maximum time
            if r>rmax
                myrands1 = paras.alpha .* sqrt(paras.h) .* (randn(k,rmax) + sqrt(-1).*randn(k,rmax));
                myrands2 = paras.alpha .* sqrt(paras.h) .* (randn(k,rmax) + sqrt(-1).*randn(k,rmax));
                r=1; % reset r
            end
            
            % evaluate slope of deterministic bit left side of interval
            fLeft = nodeFunc(y,beta,gamma,paras) + coupFunc(y,beta,gamma,B);
            
            % prediction euler's step
            yBar = y + paras.h.*fLeft + myrands1(:,r);
            
            % correction
            fRight = nodeFunc(yBar,beta,gamma,paras) + coupFunc(yBar,beta,gamma,B);
            % save current values for interpolation
            yOrig = y;
            % next values
            y = y + paras.h .* (fLeft+fRight) ./ 2 +  myrands1(:,r);
            
            escNode = find(abs(y)>paras.thresh)';
            escTest = find(X(escNode) ==0 );
            
            if ~isempty(escTest)   % check node escape
                X(escNode(escTest))=1;
                % linear interpolation for escape times
                timeInterp = (paras.thresh - abs(yOrig(escNode(escTest))))./(abs(y(escNode(escTest)))-abs(yOrig(escNode(escTest))));
                tau(escNode(escTest))= t + timeInterp.*paras.h;
            end
            
            t=t+paras.h;                          % next time step
            r = r+1;
            
            if ~any(tau==0) % all nodes have escaped if none of the times are zero
                break;
            end
        end
        
            Taunam=sprintf(['hopf_times_' num2str(n) coup '_kmax' num2str(kmax) '_beta' strrep(num2str(beta),'.','pt') '_gamma' strrep(num2str(gamma),'.','pt') '.dat']);
            fileID = fopen(Taunam,'w'); % creates file
            fprintf(fileID,'%15.15f\n',tau); % each row becomes a column
            fclose(fileID);
        
    end
    
end

