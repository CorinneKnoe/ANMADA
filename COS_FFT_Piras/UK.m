function [U]=UK(k,style,a,b)
%The function calculates the U_k function based on on Fang and
%Oosterlee(2008) equation (29).
%==========================================================================
% INPUT     k           1xn .. intergers from 0 to N-1
%           style       1x1 .. Call or Put (Call-> style =1, else Put)
%           a           1x1 .. lower end-point interval COS-FFT
%           b           1x1 .. upper end-point interval COS-FFT
%           ---------------------------------------------------------------
% OUTPUT    U           1x1 .. Function-Value of Uk 
%==========================================================================
% USAGE     UK(k,style,a,b)
% EXAMPLE   UK(1,1,-2.5,2.5) 
% AUTHOR:       Gion Donat Piras;           Marcial Messmer 
% CONTACT:      donatpiras@gmail.com;       marcial.messmer@gmail.com 
% DATE      2012-01-02
%==========================================================================
%OUTPUT
if style==1             %for call
   U=2/(b-a)*(chi(0,b,a,b,k)-psi(0,b,a,b,k));
else                    %for put
   U=2/(b-a)*(chi(0,a,a,b,k)-psi(0,a,a,b,k));
end

%The subfunctions calculate the cosine series coeffecient chi and psi based
%on Fang and Oosterlee(2008)- equation (20) and (21). 
function y_1=chi(c,d,a,b,k)
    
    y_1=1./(1+(k.*pi/(b-a)).^2).*(cos(k.*pi*(d-a)/(b-a))*exp(d)-cos(k.*pi*(c-a)/(b-a))*exp(c)...
        +(k.*pi/(b-a)).*sin(k.*pi*(d-a)*(b-a))*exp(d)-(k.*pi/(b-a)).*sin(k.*pi*(c-a)/(b-a))*exp(c));

function y_2=psi(c,d,a,b,k)
y_2=(b-a)./(k*pi).*(sin(k*pi.*(d-a)./(b-a))-sin(k*pi.*(c-a)./(b-a)));
y_2(1)=d-c;



