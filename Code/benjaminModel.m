function z=benjaminModel(net,p,c,flag)
%       Benjamin Model - diffusive, additive, and mixed coupling
% Call function:
%            z=benjaminModel(net,p,c)
% Inputs:
%     net - network (square matrix)
%     p   - vector of parameters:
%           p(1) = lambda (Excitability parameter)
%           p(2) = alpha  (Noise amplitude)
%           p(3) = omega  (Oscillatory frequency)
%           p(4) = beta   (Global scaling coupling, for both diffusive
%                            (c=0) and additive coupling (c=1)
%           p(5) = gamma  (Global scaling coupling, additive term in the
%                            generalised coupling framework)
%     c   - coupling flag:
%           if c==0 then diffusive coupling
%           if c==1 then additive coupling
%           if c==2 then mixed coupling (gamma and beta)
%     flag - = 0 (BNI) or =1 (NI), so that the normalisation is correct
%
% Output:
%     z   - time series of each node (time x nodes)
%
% Typical values for p: 
% p(1)=0.8; p(2)=0.05; p(3)=20; p(4)=3; 
%
% Assumption: n(i,j) stands for connection from i to j
%
% M.Lopes @ 2017, updated 2021-06-11
% v1 (2021-06-14): optimization
% v2 (2021-07-30): inclusion of flag for NI computation


% Parameters:
lambda = p(1); 
alpha  = p(2); 
omega  = p(3); 
beta   = p(4); 
if c==2
    if numel(p)<5
        error('Gamma is missing');
    end % Note: the mex file compilation does not allow to define gamma inside of a if condition
end

indegree = (sum(net,1))';
net = net'; % for vectorization and keeping with i->j in a(i,j)
N=size(net,1);

% normalisation of coupling
if flag==0 % BNI
    M=N;
elseif flag==1 % NI
    M=N+1;
else
    error('The flag argument should be either 0 for BNI or 1 for NI.');  
end


dt=0.001;      
T=50/dt;       
z=complex(zeros(N,T));  
noise=alpha*sqrt(dt);
for k=1:T-1
    f=(lambda-1+1i*omega)*z(:,k)+2*z(:,k).*abs(z(:,k)).^2-z(:,k).*abs(z(:,k)).^4;
    ns=randn(N,2);
    NoiseTerm = noise*(ns(:,1)+1i*ns(:,2));    
    
    switch c
        case 0 % Diffusive coupling
            z(:,k+1)=z(:,k)+dt*f+NoiseTerm+...
                dt*beta*(1/M)*net*z(:,k) - dt*beta*(1/M)*indegree.*z(:,k);
            
        case 1 % Additive coupling
            z(:,k+1)=z(:,k)+dt*f+NoiseTerm+...
                dt*beta*(1/M)*net*z(:,k);
            
        case 2 % Generalised coupling
            z(:,k+1)=z(:,k)+dt*f+NoiseTerm+...
                dt*(p(5)+beta)*(1/M)*net*z(:,k) - dt*beta*(1/M)*indegree.*z(:,k);
            
    end
end      