function [xdot] = vdpol(t,x)
% define variables 
global C a ts X drop_next count offset X0 
% set up dsifferential equation matrix
xdot = zeros(6,1);
for l=1:5
    K=0;
    for n=1:5
    R(offset+n)=(a(offset+n) + x(1)/C);
    K = K + x(offset+n)./R(offset+n);
    end
    xdot(1) = -1.0*C +  K;
    xdot(l+offset) = 1.0/R(offset+l) - p(x(1),t).*(x(l+offset).*x(l+offset)./(2.0*R(offset+l)));
end
% adjustment
if (xdot(1)+x(1) < 0.0)
       xdot(1) = -1.0*x(1);
end

for i=1:5
    if (x(i+offset)+xdot(i+offset) < 0.0)
      xdot(i+offset) = -1.0*x(i+offset);
    end
end

end