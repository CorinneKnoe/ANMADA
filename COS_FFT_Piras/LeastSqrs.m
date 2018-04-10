function y=LeastSqrs(Style,OptPriceMK,x,K,tau,r,mu,uBar,lambda,eta,rho,U_0)
%Square Error function, it calculates the quadric deviation of market vs.
%model prices
%==========================================================================
% USAGE    LeastSqrs(Style,OptPriceMK,x,K,tau,r,mu,uBar,lambda,eta,rho,U_0)
% AUTHOR       Gion Donat Piras;           Marcial Messmer 
% CONTACT      donatpiras@gmail.com;       marcial.messmer@gmail.com 
% DATE         2012-01-05
%==========================================================================
%--Estimation Parameters---------------------------------------------------
    %FVr_temp(1)    uBar
    %FVr_temp(2)    lambda
    %FVr_temp(3)    eta
    %FVr_temp(4)    rho
    %FVr_temp(5)    U_0
 %--------COS-FFT----------------------------------------------------------
    a=-10*sqrt(uBar+uBar*eta);  % interval length - 10 std deviations
    b=10*sqrt(uBar+uBar*eta);
    N=50;
    k=0:N-1;
    omega=k.*pi/(b-a);
 %=========================================================================       
    N=length(K);
    OptPriceCOS=zeros(N,1);
    weights=ones(1,length(k)); weights(1)=0.5; %weighting the first element (k=0) with only 1/2
    Uk=UK(k,Style,a,b);
    for g=1:N
        OptPriceCOS(g)=K(g)*exp(-r(g)*tau(g)).*real(sum(weights.*(cfHes(omega,U_0,tau(g),uBar,lambda,eta,mu(g),rho).*...
                        exp(1i*omega*(x(g)-a)).*Uk)));  %model pricing                      
    end
    y=sum((OptPriceMK-OptPriceCOS).^2); %square function