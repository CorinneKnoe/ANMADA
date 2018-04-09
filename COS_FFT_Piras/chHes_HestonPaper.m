%function [f_1 f_2]=heston(s,sigma,t,gamma)
%Function calculates the probabilities(charateristic equation) for pricing options in a Heston Model 
% INPUT   s      1x1 .. current stock price
%         sigma  1x1 .. current standard deviation
%         t      1xm .. time to maturity in years
%         gamma  1xn .. parameter vector of dimension
% OUTPUT  y      1x1 .. value/price of the option
% USAGE heston(s,sigma,t,gamma)
% EXAMPLE 1 
% EXAMPLE 2 
% AUTHOR: Marcial Messmer CONTACT: marcial.messmer@gmail.com, DATE: 2011-12-16
clear all
s=100;vega=0.16;t=1;phi=0.1;
x=log(s)
%INPUT-PARAMETER
    u(1)=1/2; 
    u(2)=-1/2;
    r=0.1;
    kappa=2;
    theta=0.09;
    lambda=2;sigma=0.4;
    rho=-0.5; a=kappa*theta;
    b(1)=kappa+lambda-rho*sigma; b(2)=kappa+lambda;
    for k=1:2
        d(k)=((phi*rho*sigma*i-b(k))^2-sigma^2*(2*u(k)*phi.*i-phi.^2)).^(1/2); 
        g(k)=(b(k)-rho*sigma*phi.*i+d(k))./(b(k)-rho*sigma*phi.*i-d(k));
        D(k)=((b(k)-rho*sigma*phi.*i+d(k))/sigma^2).*((1-exp(d(k)*t))./(1-g(k).*exp(d(k)*t)));
        C(k)=r*phi.*i*t+(a/sigma^2)*((b(k)-rho*sigma*phi.*i+d(k))*t-2*log((1-g(k).*exp(d(k)*t))./(1-g(k))));
    end
f_1=exp(C(1)+D(1).*vega+phi*i*x);
f_2=exp(C(2)+D(2).*vega+phi*i*x);




