function phiHest=cfHes(omega,u_0,tau,ubar,lambda,eta,mu,rho)
%Function calculates the characteristic equation of the Heston Model based 
%on Fang and Oosterlee(2008), page 8.
%==========================================================================
% INPUT     omega       1xn .. value
%           u_0         1x1 .. initial variance of underlying
%           tau         1x1 .. time to maturity
%           ubar        1x1 .. mean level of variance
%           lambda      1x1 .. speed of mean reversion
%           eta=0.4;    1x1 .. volatility of volatility
%           mu=0.01;    1x1 .. drift of stock price
%           rho=-0.5;   1x1 .. correlation coeffecient of two dimensional BM
%           ---------------------------------------------------------------
% OUTPUT    phiHest     1x1 .. value of characteristic function
%==========================================================================
% USAGE     cfHes(omega,u_0,tau,ubar,lambda,eta,mu,rho)
% EXAMPLE   cfHes(1,0.3,2,0.4,2,0.2,0.01,-0.5)
% AUTHOR    Gion Donat Piras;           Marcial Messmer 
% CONTACT   donatpiras@gmail.com;       marcial.messmer@gmail.com 
% DATE      2012-01-02
%==========================================================================
    D=((lambda-1i*rho*omega.*eta).^2+(omega.^2+omega.*1i)*eta^2).^(1/2);
    G=(lambda-1i*rho*omega.*eta-D)./(lambda-1i*rho*omega.*eta+D);
    phiHest=exp(1i*omega*mu*tau+(u_0/eta^2)*((1-exp(-D.*tau))./(1-G.*exp(-D*tau))).*(lambda-1i*rho*omega*eta-D)).*...
            exp(((lambda*ubar)/eta^2)*(tau*(lambda-1i*rho*omega*eta-D)-2*log((1-G.*exp(-D*tau))./(1-G))));