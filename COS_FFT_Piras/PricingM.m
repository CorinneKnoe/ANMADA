%% ========Heston Model - Option Pricing with COS-FFT and MC===============
% Description:  The program prices Options with two different pricing
%               methods based on the Heston Model. The first method (b)is 
%               the so called COS-FFT based on Fang and Oosterlee (2008). 
%               The second one is based on a Monte-Carlo-Simulation.
%               Additionally part (c) of the program provides an
%               estimation procedure utilizing differential evolution
%               (http://www.icsi.berkeley.edu/~storn/code.html). Optionally
%               the Black-Scholes price can be calculated as a benchmark.
% AUTHOR:       Gion Donat Piras;           Marcial Messmer 
% CONTACT:      donatpiras@gmail.com;       marcial.messmer@gmail.com 
% DATE:         2012-01-02
%==========================================================================
%PRE-CLEANING
    clear all
    clc 
%==========================================================================
tic
%GENERAL SET-UP
    %-------Settings-----------------------------
    estPar=0;   % if estPar=1, Heston parameters will be estimated
    PlotP=1;    % if plot=1, show plot of optionprices
    bmBS=1;     % if bmBS=1, include Black-Scholes as Benchmark Case    
    %-------Option parameters--------------------
    Style=1;    % if 1 then call, else put
    S_0=100;    % initial asset price (at t=0)
    K=10:120;   % strike prices (vector possible)
    tau=1;      % time to maturity in years
    r=0.1;      % interest rate annualized
    U_0=0.16;   % initial variance (at t=0)
    %-------Heston parameters--------------------
    uBar=0.2;   % mean level of variance
    lambda=2;   % speed of mean reversion
    eta=0.4;    % volatility of volatility
    mu=r;       % drift BM (set equal to risk free rate)
    rho=-0.5;   % correlation coeffecient of two-dimensional BM
    x=log(S_0./K); 
%% (b) COS-FFT Pricing=====================================================
%Implementation following Fang and Oosterlee(2008) p.8
%INPUT
    a=-10*sqrt(uBar+uBar*eta);  % interval length - 10 std deviations
    b=10*sqrt(uBar+uBar*eta);
    N=50;
    k=0:N-1;
    omega=k.*pi/(b-a);
%==========================================================================
%OUTPUT
    OptPriceCOS=zeros(1,length(K));
    weights=ones(1,N); weights(1)=0.5; %weighting the 1st element(k=0) with 1/2
    Uk=UK(k,Style,a,b); 
    for g=1:length(K)
        OptPriceCOS(g)=K(g)*exp(-r*tau).*real(sum(weights.*(cfHes(omega,U_0,tau,uBar,lambda,eta,mu,rho).*...
                        exp(1i*omega*(x(g)-a)).*Uk)));
    end
%% (c) Estimation==========================================================
if estPar==1
    Rundeopt    %calls differential evolution estimation
end
%% (d) MC-Simulation Pricing===============================================
%INPUT
    %Simulation Set-up
    M=10000;    % number of simulations
    n=100;      % time steps
    dt=tau/n;   % length of each time step
%==========================================================================
%OUTPUT
    Z1 = randn(M,n); Z2 = randn(M,n);   % normal simulation for BM 
    dW1 = sqrt(dt)*Z1;                  % 1st increment 2-dimensional BM
    dW2 = eta*sqrt(dt)*(rho*Z1 + sqrt(1-rho^2)*Z2); %2nd increment 2-d. BM
    
    simPrice=zeros(M,length(K));        %simulated Price of each run
    zeroV=zeros(1,length(K));
    U=zeros(1,n); S=zeros(1,n);
    U(1)=U_0; S(1)=S_0;        %set variance (asset value) to initial level 
    for k=1:M
     
        for t=2:n
            U(t)=U(t-1)-lambda*(U(t-1)-uBar)*dt+sqrt(U(t-1))*dW2(k,t-1);
            S(t)=S(t-1)*(1+(mu)*dt+sqrt(U(t-1))*dW1(k,t-1));
        end
        
        if Style == 1                       % if call or put
            simPrice(k,:)=max(real(S(n))-K,0);   % call-option price at T
        else 
            simPrice(k,:)=max(K-real(S(n)),0);   % put-option price at T
        end
    end
    
    OptPriceMC=exp(-r*tau).*(mean(simPrice));
toc  
%% (*)Black-Scholes Benchmark==============================================
if bmBS==1
    OptPriceBS=BlackScholes(Style,S_0,K,tau,r,uBar);
end
%% Results=================================================================
   display(OptPriceCOS);   
   display(OptPriceMC);
   if bmBS==1
       display(OptPriceBS);
   end
   
 %PLOT=====================================================================
   if PlotP==1                          
        plot(K,OptPriceCOS,'Color',[1 0 0])
        hold on
        plot(K,OptPriceMC,'Color',[0 1 0])
        if bmBS==1
            hold on
            plot(K,OptPriceBS,'Color',[0 0 1])
            leg=legend('OptPriceCOS','OptPriceMC','OptPriceBS');
        else
            leg=legend('OptPriceCOS','OptPriceMC');
        end
        title('Option Prices of Models ');
        xlabel('Strike K'); ylabel('Price Option');
        leg;
   end  
   
   