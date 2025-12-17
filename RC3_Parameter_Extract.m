load("OCV_data_251215.mat")
Current = data(:,5);
Voltage = data(:,6);
Samplingtime = 1;

Parameter = 0;

for i = 2 : length(Current)
   if Current(i-1,1) > -0.05 && Current(i,1) < -0.05
      Parameter = Parameter + 1;

      OCV_fit(Parameter,1) = Voltage(i-1,1);
      R0_est(Parameter,1) = (OCV_fit(Parameter,1) - Voltage(i,1)) / abs(Current(i,1));

      V_min_index=0;
      for k = i+1 : length(Current) - 1
         if Current(k,1) < -0.05 && Current(k+1,1) > -0.05
            V_min(Parameter,1) = Voltage(k-1,1);
            V_min_index = k;
            break;
         end
      end
      vol_632 = (Voltage(i,1)-V_min(Parameter,1))*0.632 + V_min(Parameter,1);
      vtau1_index = 0;
      for k = i+1 : V_min_index-1
        if (Voltage(k) >= vol_632) && (Voltage(k+1) < vol_632)
            vtau1_index = k;
            break;
        end
      end
      vol_632_2 = (Voltage(vtau1_index,1)- V_min(Parameter,1))*0.632 + V_min(Parameter,1);
      vtau2_index = 0;
      for k = vtau1_index+1 : V_min_index-1
        if (Voltage(k) >= vol_632_2) && (Voltage(k+1) < vol_632_2)
            vtau2_index = k;
            break;
        end
      end
      if vtau1_index==0 || vtau2_index==0
        continue;
      end
      R1_est(Parameter,1) = (Voltage(i,1) - Voltage(vtau1_index,1)) / abs(Current(i,1));
      tau1(Parameter, 1) = (vtau1_index -i)*Samplingtime;
      C1_est(Parameter,1) = tau1(Parameter, 1)/R1_est(Parameter, 1);

      R2_est(Parameter,1) = (Voltage(vtau1_index,1) - Voltage(vtau2_index,1)) / abs(Current(vtau1_index,1));
      tau2(Parameter, 1) = (vtau2_index - vtau1_index) * Samplingtime;
      C2_est(Parameter,1) = tau2(Parameter, 1)/R2_est(Parameter, 1);

      R3_est(Parameter,1) = (Voltage(vtau2_index,1) - V_min(Parameter,1)) / abs(Current(vtau2_index,1));
      tau3(Parameter, 1) = (V_min_index - vtau2_index) * Samplingtime;
      C3_est(Parameter,1) = tau3(Parameter, 1)/R3_est(Parameter, 1);

      
      %Voltage(i,1)-V_min 
   end
end

% R1_RC3 = R1_RC3/10;
% R1_RC3(1:4) = R1_RC3(1:4)*10;
% R2_RC3(1) = R2_RC3(1)*2;
% R3_RC3(1) = R3_RC3(1)*2;
% R1_RC3(19:20) = R1_RC3(19:20) / 10;
% R2_RC3(19:20) = R2_RC3(19:20) / 10;
% %C1_RC3(19) = C1_RC3(19)*10;
% %C2_RC3(19) = C2_RC3(19)*10;
% R0_RC3(18) = R0_RC3(18)/10;
% R0_RC3(4) = R0_RC3(4)/10;
OCV_fit(21,1) = Voltage(end,1);
OCV_fit = flipud(OCV_fit);

R0_est = flip(R0_est);
R0_est = [R0_est(1); R0_est];
R1_est = flip(R1_est);
R1_est = [R1_est(1); R1_est];
R2_est = flip(R2_est);
R2_est = [R0_est(1); R2_est];
R3_est = flip(R3_est);
R3_est = [R3_est(1); R3_est];

C1_est = flip(C1_est);
C1_est = [C1_est(1); C1_est];

C2_est = flip(C2_est);
C2_est = [C2_est(1); C2_est];

C3_est = flip(C3_est);
C3_est = [C3_est(1); C3_est];

time = length(Current);
t = [0:1:time-1]';

Current_in = [t Current];
Voltage_in = [t Voltage];


SOC_OCV = [0:0.05:1]'; %21개
SOC_RC = [0:0.05:1]'; %20개 -> 21개?



RC3_vol_before = out.ScopeVoltage.signals(2).values