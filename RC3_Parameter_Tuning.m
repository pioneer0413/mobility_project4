%%
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


      for k = i+1 : length(Current) - 1
         if Current(k,1) < -0.05 && Current(k+1,1) > -0.05
            V_min(Parameter,1) = Voltage(k-1,1);
            break;
         end
      end

      R1_est(Parameter,1) = (Voltage(i,1) - V_min(Parameter,1)) / abs(Current(i,1));
      Tau_v(Parameter,1) = ((Voltage(i,1) - V_min(Parameter,1)) * (36.8/100)) + V_min(Parameter,1);
      i2=0;
      for k = i+1 : length(Current) - 1
         if (Voltage(k,1) >= Tau_v(Parameter, 1)) && (Voltage(k+1,1) < Tau_v(Parameter, 1))
            Tau(Parameter, 1) = (k-i) * Samplingtime;
            i2 = k;
            break;
         end
      end
      C1_est(Parameter,1) = Tau(Parameter, 1) / R1_est(Parameter,1);


      R2_est(Parameter,1) = (Voltage(i2,1) - V_min(Parameter,1)) / abs(Current(i2,1));
      Tau_v(Parameter,1) = ((Voltage(i2,1) - V_min(Parameter,1)) * (36.8/100)) + V_min(Parameter,1);
      i3=0;
      for k = i2+1 : length(Current) - 1
         if (Voltage(k,1) >= Tau_v(Parameter, 1)) && (Voltage(k+1,1) < Tau_v(Parameter, 1))
            Tau(Parameter, 1) = (k-i2) * Samplingtime;
            i3 = k;
            break;
         end
      endㄴ

      C2_est(Parameter,1) = Tau(Parameter, 1) / R2_est(Parameter,1);

      R3_est(Parameter,1) = (Voltage(i3,1) - V_min(Parameter,1)) / abs(Current(i3,1));
      Tau_v(Parameter,1) = ((Voltage(i3,1) - V_min(Parameter,1)) * (36.8/100)) + V_min(Parameter,1);
      for k = i3+1 : length(Current) - 1
         if (Voltage(k,1) >= Tau_v(Parameter, 1)) && (Voltage(k+1,1) < Tau_v(Parameter, 1))
            Tau(Parameter, 1) = (k-i3) * Samplingtime;
            break;
         end
      end

      C3_est(Parameter,1) = Tau(Parameter, 1) / R3_est(Parameter,1);

      
      %Voltage(i,1)-V_min 
   end
end

R1_est = R1_est/10;
R1_est(1:4) = R1_est(1:4)*10;
R2_est(1) = R2_est(1)*2;
R3_est(1) = R3_est(1)*2;
R1_est(19:20) = R1_est(19:20) / 10;
R2_est(19:20) = R2_est(19:20) / 10;
%C1_RC3(19) = C1_RC3(19)*10;
%C2_RC3(19) = C2_RC3(19)*10;
R0_est(18) = R0_est(18)/10;
R0_est(4) = R0_est(4)/10;
OCV_fit(21,1) = Voltage(end,1);
OCV_fit = flipud(OCV_fit);









 
time = length(Current);
t = [0:1:time-1]';

Current_in = [t Current];
Voltage_in = [t Voltage];


SOC_OCV = [0:0.05:1]'; %21개
SOC_RC = [0.05:0.05:1]'; %20개
