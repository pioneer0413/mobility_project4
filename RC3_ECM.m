data = xlsread('33J battery OCV test data.xlsx');

Current = data(:,1);
Voltage = data(:,2);
Samplingtime = 1;

Parameter = 0;

for i = 2 : length(Current)
   if Current(i-1,1) > -0.05 && Current(i,1) < -0.05
      Parameter = Parameter + 1;

      OCV(Parameter,1) = Voltage(i-1,1);
      Ri(Parameter,1) = (OCV(Parameter,1) - Voltage(i,1)) / abs(Current(i,1));


      for k = i+1 : length(Current) - 1
         if Current(k,1) < -0.05 && Current(k+1,1) > -0.05
            V_min(Parameter,1) = Voltage(k-1,1);
            break;
         end
      end

      Rdiff(Parameter,1) = (Voltage(i,1) - V_min(Parameter,1)) / abs(Current(i,1));
      Tau_v(Parameter,1) = ((Voltage(i,1) - V_min(Parameter,1)) * (36.8/100)) + V_min(Parameter,1);

      for k = i+1 : length(Current) - 1
         if (Voltage(k,1) >= Tau_v(Parameter, 1)) && (Voltage(k+1,1) < Tau_v(Parameter, 1))
            Tau(Parameter, 1) = (k-i) * Samplingtime;
            break;
         end
      end

      Cdiff(Parameter,1) = Tau(Parameter, 1) / Rdiff(Parameter,1);
   end
end

OCV(21,1) = Voltage(end,1);




 
