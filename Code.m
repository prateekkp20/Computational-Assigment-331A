% Define the constant values k1 and K2
k1 = input('Enter k1: ');
K2 = input('Enter k2: ');

% Define the function f(Ca)
syms Ca
f(Ca) = (k1*Ca)/(1 + K2*Ca^2);

% Define the domain of the function
Ca_min = input('Enter Ca_min: ');
Ca_max = input('Enter Ca_max: ');

% (a) Derivative at a point
disp('Calculating derivative at a point')
Ca_point = input('Enter the point: ');
df_dCa = diff(f);
derivative=vpa(subs(df_dCa,Ca,Ca_point));
fprintf('The derivative at %d is %s\n',Ca_point,derivative);

% (b) Area under the curve
C = linspace(Ca_min,Ca_max);
Area = trapz(C, f(C));
fprintf('The area under the curve is: %s\n',vpa(Area))
plot(C,f(C));
hold on;

% (c) Finding minimum or maximum functional value
[minimum, minimum_index] = min(f(C));
[maximum, maximum_index] = max(f(C));
fprintf('The minimum value in the given domain is %s \n',vpa(minimum));
fprintf('The maximum value in the given domain is %s \n',vpa(maximum));

% (d) Drawing a straight line between two points on the function
disp('Drawing a straight line between two points on the function');
Ca1 = input('Enter the first point: ');
Ca2 = input('Enter the second point: ');
y1 = f(Ca1);
y2 = f(Ca2);
slope = (y2 - y1)/(Ca2 - Ca1);
intercept = y1 - slope * Ca1;
line = @(x) slope * x + intercept;
plot([vpa(Ca1) vpa(Ca2)],[vpa(y1) vpa(y2)]);
fprintf('Slope of the line is %s \n',vpa(slope));
fprintf('Intercept on the Y-axis is %s \n',vpa(intercept));

% (e) Searching for a point where the tangent is the same as the given slope
% solving the problem using the bisection method
format long 
slope_target=input('Enter the slope Target: \n');
f_bisection = diff(f)-slope_target;
a = input('Enter first starting point\n');
b = input('Enter second starting point\n');
disp('Now subsequent enter stopping criteria: ');
rel_err = input('Enter the percentage relative error allowed in solution\n');
func_value = input('Enter Convergence criteria for the function value, i.e., how close f(x) is to zero\n');
max_iter = input('Enter allowed maximum number of iterations\n');
              
c1 = 0;
iter = 0;
c2 = (a+b)/2;
err = abs(100*(c2-c1)/c2);
stop_err = 0;
stop_iter=0;
stop_value=0;
i=1;

while ((err > rel_err) && (iter<max_iter) &&(abs(f_bisection(c2))>func_value))
    if(f_bisection(a)*f_bisection(b)<0)
        c2 = (a+b)/2;
        if(f_bisection(a)*f_bisection(c2)<0) b = c2;
        else a = c2;
        end
    end
    err = abs(100*(c2-c1)/c2);
    c1 = c2;
    p=c2;
    errg(i)=err;
    iter = iter + 1;
    i=i+1;
    if(err<rel_err)
        stop_err=1;
    end

    if(abs(f_bisection(c2))<func_value)
        stop_value=1;
    end
    if(iter==max_iter)
        stop_iter=1;
    end
end

fprintf('Root is %f\n',p);

if(stop_err)
    disp('Iterations stopped as relative error stopping criteria was met');
end

if(stop_iter)
    disp('Iterations stopped as maximum number of iterations were executed');
end

if(stop_value)
    disp('Iterations stopped as function value was close to zero as required');
end

%else this was the other method
% Ca_tangent = fzero(@(x) (diff(f) - slope_target), [Ca_min,Ca_max]);