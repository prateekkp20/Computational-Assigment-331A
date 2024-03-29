clear
Ca0 = [2 5 6 6 11 14 16 24]; % given inlet flow rate data
Ca = [0.5 3 1 2 6 10 8 4]; % given outlet flow rate data
T_res = [30 1 50 8 4 20 20 4]; % given tau data
rA_inv = T_res./(Ca0 - Ca); % inverse of rate the reaction
xQ = 0.5:0.01:10; 
yQ = spline(Ca,rA_inv,xQ); % cubic spline interpolation of the data
pp = spline(Ca,rA_inv); % function of the spline interpolation


Ca_i = input('The inlet concentration:');
Ca_out = input('The exit concentration:');
vo = input('The flow rate:');
disp('(A) To find minimum volume for PFR ');
disp('(B) To find minimum volume for MFR ');
disp('(C) To find minimum volume for 2 MFRs ');
disp('(D) To find minimum volume for MFR followed by PFR ');
disp('(E) To find minimum volume for PFR with recycle');
n = input('Enter the part to solve: ',"s");
%Ca_out = 1;
%Ca_in = 10;
%v0 = 0.1;

%for a single PFR
if n == 'A'
    int_values = Ca_out:0.1:Ca_i;
    rA_inver = spline(Ca,rA_inv,int_values);
    AreaUnderCurve = trapz(int_values, rA_inver); % calculating the required area under the curve for PFR
    V_min = vo*AreaUnderCurve; %Volume = flowrate * area
    disp(['The volume of PFR required (in Lit): ', num2str(V_min)]);
    hold on;
    area(int_values,rA_inver); %coloring the area under the curve
    plot(xQ, yQ,'b', 'LineWidth', 1.5); %plotting -1/rA vs Concentration Curve obtained from spline interpolation
    plot(Ca,rA_inv,'ko','LineWidth',1.5,'MarkerSize',4); %plotting the given data points 
    xlabel('Ca')
    ylabel('-1/rA')
    title('-1/rA vs Concentration Curve')
    grid on
end


%for a single CSTR
if n == 'B'
        rA_f = spline(Ca,rA_inv,Ca_out);
        V_min_CSTR = (Ca_i - Ca_out)*rA_f*vo;
        disp(['The volume of CSTR required (in Lit): ', num2str(V_min_CSTR)]);
        X = [Ca_i, Ca_out];
        Y = [rA_f, rA_f];
        area(X,Y);%coloring the area under the curve
        hold on;
        plot(xQ, yQ,'k', 'LineWidth', 1.5); %plotting -1/rA vs Concentration Curve obtained from spline interpolation
        plot(Ca,rA_inv,'ko','LineWidth',1.5,'MarkerSize',4); %plotting the given data points 
        xlabel('Ca')
        ylabel('-1/rA')
        title('-1/rA vs Concentration Curve')
        grid on
        
end



%for two CSTRs
if n == 'C'
        rA_in = spline(Ca,rA_inv,Ca_i); %rate at inlet concentration
        rA_out = spline(Ca,rA_inv,Ca_out); %rate at outlet concentration
%this part is done using the technique of minimization of rectangles
%the min area occurs when the slope of the curve at a given point is
%equal to the slope of the hypotenuse formed due to the two  triangles
%here we have created a function to calculate the area when the outlet conc
%of first cstr is C. Then we created the array for all the C values and
%found the min area among them using the min function
        Area = @(C) (Ca_i - C).*(spline(Ca,rA_inv,C)) + (C-Ca_out).*((spline(Ca,rA_inv,Ca_out)));
        [min_area, Ca_mid] = min(Area(xQ));
        V_1 = (Ca_i - xQ(Ca_mid))*(spline(Ca,rA_inv,xQ(Ca_mid)))*vo; %volume of the first CSTR
        V_2 = (xQ(Ca_mid)-Ca_out)*(spline(Ca,rA_inv,Ca_out))*vo; %volume of the second CSTR
        Vtotal = min_area*vo;
        disp(['The total minimum value in case of two CSTRs: ', num2str(Vtotal)]);
        disp(['The volume of CSTR1: ', num2str(V_1)]);
        disp(['The volume of CSTR2: ', num2str(V_2)]);
        %coloring the area of first CSTR
        X = [Ca_i, xQ(Ca_mid)];
        Y = [spline(Ca,rA_inv,xQ(Ca_mid)) , spline(Ca,rA_inv,xQ(Ca_mid))];
        area(X,Y);
        %coloring the area of second CSTR
        X1 = [xQ(Ca_mid),Ca_out];
        Y1 = [rA_out, rA_out];
        hold on;
        area(X1,Y1);
        plot(xQ, yQ,'k', 'LineWidth', 2); %plotting -1/rA vs Concentration Curve obtained from spline interpolation
        plot(Ca,rA_inv,'ko','LineWidth',2,'MarkerSize',4); %plotting the given data points 
        xlabel('Ca')
        ylabel('-1/rA')
        title('1/rA vs Concentration Curve')
        grid on
        %now me calculate and plot the lines
        m = (rA_out-yQ(Ca_mid))/(xQ(Ca_mid)-Ca_i);
        c = rA_out - m*xQ(Ca_mid);
        line_diagonal = m*Ca + c;
        c2 = yQ(Ca_mid) - m*xQ(Ca_mid);
        line_slope = m*Ca + c2;
        plot(Ca, line_diagonal, 'r', 'LineWidth', 1);
        hold on;
        plot(Ca, line_slope, 'b', 'LineWidth', 1);


        
end

if n == 'D'
        %combination of PFR and CSTR
        %here we find the minumum -1/rA and divide the area into pfr and
        %cstr at that point
        f = @(x) spline(Ca,rA_inv,x) ;
        [min_area2, Ca_mid2] = min(f(xQ));
        %volume of the CSTR required
        V_1 = (Ca_i - xQ(Ca_mid2))*(spline(Ca,rA_inv,xQ(Ca_mid2)))*vo;
        x_values = Ca_out:0.01:xQ(Ca_mid2);
        rA_x_values = spline(Ca,rA_inv,x_values);
        V_2 = trapz(x_values, rA_x_values)*vo; %volume of the PFR required
        V_tot = V_1 + V_2; %total volume
        disp(['The total minimum value in case MFR followed by PFR ', num2str(V_tot)]);
        disp(['The volume of MFR is: ', num2str(V_1)]);
        disp(['The volume of PFR is: ', num2str(V_2)]);
        %coloring the area of CSTR
        X1 = [Ca_i; xQ(Ca_mid2)];
        Y1 = [yQ(Ca_mid2),yQ(Ca_mid2) ];
        hold on;
        area(X1,Y1);
        %coloring the area of pfr
        area(x_values,rA_x_values);
        plot(xQ, yQ,'k', 'LineWidth', 2);%plotting -1/rA vs Concentration Curve obtained from spline interpolation
        plot(Ca,rA_inv,'ko','LineWidth',2,'MarkerSize',4);%plotting the given data points
        xlabel('Ca')
        ylabel('-1/rA')
        title('1/rA vs Concentration Curve')
        grid on
end


if n == 'E'
        %PFR with recycle
        C1 =fsolve(@(C1) (C1 - Ca_out).*ppval(pp,C1) - trapz((Ca_out: 0.01:C1),ppval(pp,(Ca_out: 0.01:C1))), 6);
        R = (Ca_i -C1)/(C1-Ca_out);
        V_rec = (Ca_i - Ca_out)*ppval(pp,C1)*vo;
        disp(['The minimum volume of PFR with recycle is: ', num2str(V_rec) ,' with recycle ratio ', num2str(R)]);
        X = [Ca_out, Ca_i];
        Y = [ppval(pp,C1), ppval(pp,C1) ];
        hold on;
        area(X,Y);        
        plot(xQ, yQ,'k', 'LineWidth', 2);
        plot(Ca,rA_inv,'ko','LineWidth',2,'MarkerSize',4);
        xlabel('Ca')
        ylabel('-1/rA')
        title('1/rA vs Concentration Curve')
        grid on
end