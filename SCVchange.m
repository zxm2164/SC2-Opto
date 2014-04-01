
%Creates a random probability that a mineral scv will be switched to a gas
%scv
function [minSCVnum gasSCVnum] = SCVchange(RefineryNum, minSCVnum, gasSCVnum)

   if (gasSCVnum < 3*RefineryNum)       %As long as there is room for more gas SCV's
        prob = rand(1);
        if (prob <= .5)                 %Give every second a 50/50 chance of switching an scv, otherwise, do nothing
            gasSCVnum = gasSCVnum + 1;
            minSCVnum = minSCVnum - 1;
        end
   end
   

end

