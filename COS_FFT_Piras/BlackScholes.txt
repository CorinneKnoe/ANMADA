function y = BlackScholes(Style,S,K,t,r,variance)
%Function calculates the price/value of an option using the Black-Scholes Model 
% INPUT   Style     1x1 .. If 1 then call, else put
%         S         1x1 .. Stockprice 
%         K         1xn .. strike prices
%         t         1x1 .. time to maturity
%         r         1x1 .. interest rate
%         variance  1x1 .. volatility
%         --------------------------------------------------------
% OUTPUT  y         1x1 .. value/price of the call
%==========================================================================
% USAGE        BlackScholes(Style,S,K,t,r,sigma)
% AUTHOR       Gion Donat Piras;           Marcial Messmer 
% CONTACT      donatpiras@gmail.com;       marcial.messmer@gmail.com 
% DATE         2012-01-02
%==========================================================================
sigma=variance^(1/2);
d1= (log(S./K)+ (r+1/2*sigma^2)*t)./(sigma*t^(1/2));
d2= d1 -sigma*t^(1/2);

if Style==1         %if call
    y = S.*(Stdn(d1))- K.*exp(-r*t).*(Stdn(d2));
else                %else put
    y= Stdn(-d2).*K*exp(-r*t)-Stdn(-d1)*S;
end
end

function y= Stdn(x)
%Function calculates the CDF of a normal distribution
% INPUT  x  1x1 .. value at which the CDF should be evaluated
% OUTPUT m  1x1 .. corresponding CDF of x
% USAGE Stdn(x)
% marcial.messmer@gmail.com, 2011-10-04
y= 0.5+0.5.*erf(x./(2^(1/2)));
end