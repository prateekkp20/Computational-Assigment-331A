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

% slope_target=input('Enter the slope Target: \n');
% Ca_tangent = fzero(@(x) (diff(f) - slope_target), [Ca_min,Ca_max]);
% Evaluate the function at the interval endpoints
f_min = double(f(Ca_min));
f_max = double(f(Ca_max));

% Check that the function values at the interval endpoints are finite and real
if ~isfinite(f_min) || ~isreal(f_min) || ~isfinite(f_max) || ~isreal(f_max)
error('Function values at interval endpoints must be finite and real.')
end

% Prompt the user for the slope target
slope_target=input('Enter the slope target: \n');

% Find the tangent point Ca_tangent using fzero
try
Ca_tangent = fzero(@(x) (diff(f) - slope_target), [Ca_min,Ca_max]);
catch
error('Unable to find a tangent point. Check that the function and interval are valid.')
end

% Display the tangent point
fprintf('The tangent point is Ca = %f\n', Ca_tangent)