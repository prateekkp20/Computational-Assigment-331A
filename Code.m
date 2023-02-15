% Define the constant values k1 and K2
k1 = input('Enter k1\n');
K2 = input('Enter k2\n');

% Define the function f(Ca)
syms Ca
f(Ca) = (k1*Ca)/(1 + K2*Ca^2);

% Define the domain of the function
Ca_min = input('Enter Ca_min\n');
Ca_max = input('Enter Ca_max\n');

% (a) Derivative at a point
Ca_point = 5;
df_dCa = diff(f);
derivative=vpa(subs(df_dCa,Ca,Ca_point));

% (b) Area under the curve
C = linspace(Ca_min, Ca_max);
AUC = trapz(C, f(C));
plot(C,f(C));

% (c) Finding minimum or maximum functional value
[minimum, minimum_index] = min(f(Ca));
[maximum, maximum_index] = max(f(Ca));

% (d) Drawing a straight line between two points on the function
Ca1 = 3;
Ca2 = 7;
y1 = f(Ca1);
y2 = f(Ca2);
slope = (y2 - y1)/(Ca2 - Ca1);
intercept = y1 - slope * Ca1;
line = @(x) slope * x + intercept;

% (e) Searching for a point where the tangent is the same as the given slope

% format longg
% f1 = f;
% f2_prime = df_dCa;
% x1 = input('Enter starting point\n');
slope_target=input('Enter the slope Target\n');
% disp('Now subsequent enter stopping criteria:');
% rel_err = input('Enter the relative error allowed in solution\n');
% % func_value = input('Enter Convergence criteria for the function value, i.e., how close f(x) is to zero\n');
% max_iter = input('Enter allowed maximum number of iterations\n');

% x2 = x1 - (f1(x1)-slope_target*x1)/f2_prime(x1);
% err = 100;
% iter = 0; 
% stop_err = 0;
% stop_iter=0;
% stop_value=0;
% i=1;

% while ((err > rel_err) && (iter<max_iter)) ...
% %         && (abs(f1(x2))>func_value))
%     x2 = x1 - f1(x1)/f2_prime(x1);
%     err = abs(100*(x2-x1)/x2);


%     if(err<rel_err)
%         stop_err=1;
%     end

%     if(abs(f1(x2))<func_value)
%         stop_value=1;
%     end
%     x1 = x2;
%     p=x2;
%     errg(i) = err;
%     iter = iter+1;
%     i=i+1;
%     if(iter==max_iter)
%         stop_iter=1;
%     end
%     error(iter)=err;
% end

% fprintf('The required Value is %f\n',p);

% if(stop_err)
%     disp('Iterations stopped as relative error stopping criteria was met');
% end

% if(stop_iter)
%     disp('Iterations stopped as maximum number of iterations were executed');
% end

% if(stop_value)
%     disp('Iterations stopped as function value was close to zero as required');
% end
Ca_tangent = fzero(@(x) (diff(f) - slope_target), [Ca_min Ca_max]);