global C ts a offset X drop drop_next count lastcount delta X0 i
i=0;
lastcount =0;
delta = 0;
count = 1;
c_count=0;
drop_next=0.1;
drop =0;
C = 0.5*1024.0*1024.0/(500.0*8);  % in unit of packet per second
ts = 1.0/C;             % time step size
%For setting propagation delay 
for i=2:6   
    a(i) = 0.1;
end

X0 = zeros(6,1);
X0(1) = 0.0;    % set average queue length = 0 at time t=0
offset=1;
for i=1:5
   X0(i+offset) = 1.0;
end
% solve the DE using ode23 over some time interval
t0=0;
tf=200.0;
%disp('enter ode45 function')
[t,X] = ode45('vdpol', [t0 tf], X0);
X_1 = abs(X(:,1)); 
X_2 = X(:,2);
X_d = X_1/C;
if X_d < 0.0
    X_d = 0.0;
end
hold on
plot(X_d, t);
hold off;
xlabel ('time in seconds (t)')
ylabel ('Queuing Delay in seconds')
