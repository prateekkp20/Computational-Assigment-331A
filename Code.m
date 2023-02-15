% Define the constant values k1 and K2
k1 = 1;
K2 = 2;

% Define the function f(Ca)
syms Ca
f(Ca) = (k1*Ca)/(1 + K2*Ca^2);

% Define the domain of the function
Ca_min = 0;
Ca_max = 10;

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
slope_target = -2;
Ca_tangent = fzero(@(x) (diff(f) - slope_target), [Ca_min Ca_max]);