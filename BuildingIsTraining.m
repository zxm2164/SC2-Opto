%This function returns 1 is there is a building available to produce the
%possibility, otherwise it outputs 0

function [ output ] = BuildingIsTraining(buildrequirementnum, que)

    if (que < (buildrequirementnum * 5))         %If the total que is maxed, then no unit can be purchased
        output = 1;                              %and the unit cannot be built
    else
        output = 0;
    end
   

end

