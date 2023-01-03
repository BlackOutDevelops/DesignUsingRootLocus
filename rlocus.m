%EEL 3657 Linear Control systems 
%Control System Design using Root Locus
%Due Augest 3, 2021
%Matthew Philpott, Christian Tomlinson, Joshua Frazer

%orginal plant
num = [ 0 0.1 16 650];          %numurator of orginal plant
den = [ 1 179 7978 7800];       %denomorator of orginal plant

%The Continuous-time transfer function for G(s)
G = tf(num,den);                %transfer function of the plant

%The Continuous-time transfer function for C(s)/R(s)
y = feedback(G,1);              %negative feed back response of plant

%Using the rlocus command we can plot Root Locus to help in controller and
%compensator design
figure(1);
rlocus(G);                      %Root locus of the plant
title('Root locus of G(s)')
grid

%Step response of the closed loop transfer function is used to visulize the
%steady state error, and overshoot as well as settling time
figure(2);
step(y);                        %step response of the tansfer function
title('Unit step response of orginal Plant')
grid

%When ploting the unit ramp we can use the closed loop transfer functions
%denominiator and multiply by s, essentually adding another 0 to the end of
%the feedback transfer function. Then again use the step function to
%visualize the ramp response of the Closed loop system

den_s = [1 179.1 794 8450 0];    %denominator multiplied by s 

gs = tf(num,den_s);             %transfer function of denomintor multiplies by s            
figure(4);
step(gs)                        %unit ramp response 
hold on
m = 1;
c = 0;
x = 0:10:500;
y = m.*x + c;
plot(x,y)
title('Unit ramp response of orginal Plant','color','black')
grid

%step response information function, helps determine if the design requirements were meet
%as well as the proper PID and lead lag response to create a system that meet
%the inital conditions
stepinfo(y)      

%poles and zeros are important to look at when it comes to the effect
%compensators will have on the parts of the orignal root locus
P = pole(G)                     %poles and zeros to help determine stability 
Z = zero(G)

%Determining that a PID controller was needed based on the order and the orginal
%transfer function is important to eliminating steady state error and determining
%the overshoot the Kp,Ki,and Kd values can be tested by trial and error
kp = 150;                       %Kp value
ki = 2;                         %Ki value
kd = 9;                         %Kd value
K =pid(kp,ki,kd);               %PID function


num_3 = [1 78];                 %zero of the lag compensator is equal to 78
den_3 = [1 1];                  %pole of the lag is set to equal a pole less then 78
lag = tf(num_3,den_3);          %Lag transfer function

kc = 10;
num_4 = [1 1];                   %zero of the lead compensator is equal to 1 same as pole of lag
num_4 = times(kc, num_4);
den_4 = [1 4];                  %pole of the lead is set to equal a value less then the next real axis pole which is 4
lead = tf(num_4,den_4);         %Lead transfer function

%The Continuous-time transfer function for G(s)*K(s)*Lead*Lag
kg = tf(K*G*lead*lag);                   %Transfer function for the plant and PID in series along with lead/lag comp.

%The Continuous-time transfer function for the new C(s)/R(s)
y2 =feedback(K*G*lead*lag,1);            %Feedback function of plant and PID in series and lead lag 


figure(5);                      
rlocus(kg);                     %root locus of plant and PID controller in series
title('Root locus of G(s) with a lead/lag compensator and PID controller in series')
grid

figure(6);                      %step response 
step(y2);
title('Unit step response with controller and compensator')
grid

%Variffy the changes that were made have a positive outvcome when meeting
%the design requirements
stepinfo(y2)                    %step response information

%Also helps in determing the changes and if they affect the control systems
%stablity.
P = pole(kg)                    %poles and zeros to help determine stability 
Z = zero(kg)

%Numerator and denominator of the closed loop transfer function multiplied
%by 1/s
num_f = [9 2301 208814 7617000 83500000 77100000 101400];
den_f= [10 2485 217691 7665000 83570000 77130000 1014000 0];


yf = tf(num_f,den_f);             %transfer function of denomintor multiplies by s  
figure(7);
step(yf);                           %unit ramp response 
hold on
m = 1;
c = 0;
x = 0:10:4000;
y = m.*x + c;
plot(x,y)
title('Unit ramp response of orginal Plant','color','black')
grid


