%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:         S_MSE= objfun(FVr_temp, S_struct)
% Author:           Rainer Storn
% Description:      Implements the cost function to be minimized.
% Parameters:       FVr_temp     (I)    Parameter vector
%                   S_Struct     (I)    Contains a variety of parameters.
%                                       For details see Rundeopt.m
% Return value:     S_MSE.I_nc   (O)    Number of constraints
%                   S_MSE.FVr_ca (O)    Constraint values. 0 means the constraints
%                                       are met. Values > 0 measure the distance
%                                       to a particular constraint.
%                   S_MSE.I_no   (O)    Number of objectives.
%                   S_MSE.FVr_oa (O)    Objective function values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S_MSE= objfun(FVr_temp, S_struct)
%Data for Estimation=======================================================
    load NEWcleanSP500X_2010-09-30.mat %load option data from Mat.file
%   --------Option Data----------------------------------------------------
    dataCall=data.calls;        % load option data
    Style=1;                    % Style of the option
    S_0=data.S;                 % get price of the underlying   
    K=dataCall(:,1);            % strikes of options
    OptPriceMK=dataCall(:,2);   % market price of option
    tau=dataCall(:,3);          % time to maturity
    r=dataCall(:,4);            % interest-rate
    %U_0=dataCall(:,8);          % initial variance /implied vola
    mu=r;                       % set equal to risk free
    x=log(S_0./K);
%   --------COS-FFT--------------------------------------------------------
    %a=-10*sqrt(0.2+0.2*0.3);  % interval length - 10 std deviations
    %b=10*sqrt(0.2+0.2*0.3);
    %N=50;
    %k=0:N-1;
    %omega=k.*pi/(b-a);
%==========================================================================

%---Peaks function----------------------------------------------
F_cost = LeastSqrs(Style,OptPriceMK,x,K,tau,r,mu,FVr_temp(1),FVr_temp(2),FVr_temp(3),FVr_temp(4),FVr_temp(5));

%----strategy to put everything into a cost function------------
S_MSE.I_nc      = 0;%no constraints
S_MSE.FVr_ca    = 0;%no constraint array
S_MSE.I_no      = 1;%number of objectives (costs)
S_MSE.FVr_oa(1) = F_cost;