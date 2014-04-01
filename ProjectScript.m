
%if supply is almost maxed, increase the probability that a supply depot
%will be built(Maybe)
%Possibly wait for some time before making another buy if chose to not buy
%anything at that time
%We are currently assuming that there is no travel time between SCV's
%movement(building to collecting)
%Still have to take multiple buildings, and units being built at the same
%time into account
%Have to include reactors and tech labs
%Keep track of build order, and supply times
%Create an army value for each unit - Army value is supposedly the mincost
%plus the gascost of each unit
%Mules and Energy
%I changed the value of buildrequirment from buildrequirement =
%building.num to the building itself, so make sure the num is referenced
%correctly in the body

%initial conditions for buildings
CommandCenter.num =              1;
CommandCenter.mincost =          400;
CommandCenter.gascost =          0;
CommandCenter.supplycost =       0;
CommandCenter.buildrequirement = 1;            %indicates that a Command Center(or another building) has no build requirements
CommandCenter.buildtime =        100*1.4;
CommandCenter.completiontimes = [];
CommandCenter.isinuse = 0;

SupplyDepot.num =               0;             
SupplyDepot.mincost =           100;
SupplyDepot.gascost =           0;
SupplyDepot.supplycost =        0;
SupplyDepot.buildrequirement = 1;
SupplyDepot.buildtime =         30*1.4;
SupplyDepot.completiontimes =   [];

Refinery.num =              0;
Refinery.mincost =          75;
Refinery.gascost =          0;
Refinery.supplycost =       0;
Refinery.buildrequirment = 1;
Refinery.buildtime =        30 * 1.4;
Refinery.completiontimes =  [];

Barracks.num =               0;
Barracks.mincost =           150;
Barracks.gascost =           0;
Barracks.supplycost =        0;
Barracks.buildrequirement = SupplyDepot;
Barracks.buildtime =         65 * 1.4;
Barracks.completiontimes =   [];
Barracks.isinuse =           0;


%initial conditions for units
minSCV.num =              6;
minSCV.mincost =          50;
minSCV.gascost =          0;
minSCV.supplycost =       1;    
minSCV.buildrequirement = CommandCenter;  %As long as command center exists, SCV's can be built
minSCV.buildtime =        17*1.4;               %17 time units multiplied by the conversion rate to seconds for "quick matches"
minSCV.completiontimes =  [];

gasSCV.num =              0;
gasSCV.mincost =          50;
gasSCV.gascost =          0;
gasSCV.supplycost =       1;    
gasSCV.buildrequirement = CommandCenter;  
gasSCV.buildtime =        17*1.4;
gasSCV.completiontimes    = [];

Mule.num = 0;
Mule.mincost = 0;
Mule.gascost = 0;
Mule.supplycost = 0;
Mule.buildrequirement = OrbitalCommandCenter;
Mule.buildtime = 0;
Mule.completiontimes = [];


Marine.num =              0;
Marine.mincost =          50;
Marine.gascost =          0;
Marine.supplycost =       1;
Marine.buildrequirement = Barracks;
Marine.buildtime =        25*1.4;     
Marine.completiontimes =  [];

Marauder.num =              0;
Marauder.mincost =          100;
Marauder.gascost =          25;
Marauder.supplycost  =      2;
Marauder.buildrequirement = 0;%[BarracksWithTechLab];
Marauder.buildtime =        30*1.4;
Marauder.completiontimes =  [];


Reaper.num =              0;
Reaper.mincost =          50;
Reaper.gascost =          50;
Reaper.supplycost =       1;
Reaper.buildrequirement = 0;%[BarracksWithTechLab];
Reaper.buildtime =        45 * 1.4;
Reaper.completiontimes   = [];

%Other Initial Conditions
SupplyCap = 10;
CurrentSupply = 6;          %Supply cost of the six SCV's
b = 0;                      %Initializing the use of this count for checking for refineries the first time

%Initializes the output data vectors and values
OldArmyValue = 0;         %Army Value
NewArmyValue = 0;
OldBuildOrder = [];       %Build Order Vector containing the names of the built units
NewBuildOrder = [];
OldSupplyCount = [];      %The "time" when the unit was created
NewSupplyCount = [];




%Play the game as many times as requested
for H = 




%A time scale from 0 to the input time length
t = 0;

while (t <= timelength)
    
    
   %Determines if a building has finished building and adds the building
   %count, and returns the scv to collecting minerals

   for buildings = [CommandCenter, SupplyDepot, Barracks]
        for (h = 1:length(buildings.completiontimes))
            if (t == buildings.completiontimes(h))
                buildings.num = buildings.num + 1;
                buildings.isinuse = buildings.isinuse -1;
                minSCV.num = minSCV.num + 1;
            end
        end
   end
   
   SupplyCap = (SupplyDepot.num * 10) + 10;         %Update the supply cap
   
   
   %Determines if a unit has finished being created and updates the number
   %of units and the ARMY VALUE!!!!!!!!!!!
   for units = [minSCV, gasSCV, Marine, Marauder, Reaper]
       for (k = 1:length(units.completiontimes))
           if (t == units.completiontimes(k))
               units.num = units.num + 1;
           end
       end
   end
   
  
   
   
   
   %Finds if a Refinery is done building and makes the corresponding SCV
   %begin collecting gas
   for b = 1:length(Refinery.completiontimes)       
       if (t == Refinery.completiontimes(b))
           gasSCV.num = gasSCV.num + 1;  %takes the constructing scv and makes him begin gas collecting if the refinery is finished
           Refinery.num = Refinery.num + 1;     %Increases the number of total refinery's if the building is finished
       end
   end
   
       
       

   
   %calculate the number of minerals available
   [Rmin Rgas] = determineResources(Rmin, Rgas, minSCV.num, gasSCV.num, Mule.num, CommandCenter.num);
   
   %If you have enough money, gas, and if the build requirements for a
   %building or unit exist, then allow it to be a choice to be produced
   
   if (SupplyCap == CurrentSupply && Rmin >= SupplyDepot.mincost && Rgas >= SupplyDepot.gascost) %If supply max is reached, build a supply depot once you have the money
       buildchoice = SupplyDepot;
       
   else
   
   
        count = 1;
        for  possibility = [CommandCenter, SupplyDepot, Refinery, Barracks, Marine, Marauder, Reaper]  %Scan through each option
               %BuildingIsTraining is a function that determines if the
               %building that produces the unit in question is already
               %making a unit
            if (Rmin >= possibility.mincost && Rgas >= possibility.gascost && min(possibility.buildrequirement.num) ~= 0 && possibility.supplycost <= (SupplyCap - CurrentSupply) && BuildingIsTraining(possibility.buildrequirement.num, possibility.buildrequirement.isinuse)== 1)
                choice(count) = possibility;          %Is A Choice
                count = count + 1;          
            end
   
        end
   
   
   
        choice(end+1) = 'Do Nothing';        %Add in the possibility that we do nothing
   
   
        %Choice section
        prob = rand(1);       %Generates the random number that will be used to make a choice
   
   
        blahvector(1:length(choice)) = 1/length(choice);
    
        testVector = cumsum(blahvector);
   
         for d = 1:length(choice)
             if prob <= cumsum(d)
                buildchoice = choice(d);
                return
             end
         end
   end
   
   
   
   
   % to set 'Do Nothing' higher to a, 
   % blahVector(1:length(choice)) = (1-a)/(length(choice)-1)
   % blahVector(find(choice == 'Do Nothing'))=a
   
   %Update Everything-Store the build order-
  
   
  %If the buildchoice is a building, decrease the number of working scv's
  %by 1
  
  if (buildchoice ~= 'Do Nothing' && buildchoice ~= Refinery && buildchoice.supplycost == 0)
      minSCV.num = minSCV.num - 1;
      buildchoice.completiontimes(end+1) = t + ceil(buildchoice.buildtime);     
  end
  
  
  %If the buildchoice is a unit, start building the unit and determine when
  %the unit will be completed
  if (buildchoice ~= 'Do Nothing' && buildchoice.supplycost > 0)
      buildchoice.completiontimes(end+1) = t + ceil(buildchoice.buildtime);
      buildchoice.buildrequirement.isinuse = buildchoice.buildrequirement.isinuse; %Increase the number of unusable buildings
      CurrentSupply = CurrentSupply + buildchoice.supplycost;       %Updates the supply count
  end
 
   
  if (buildchoice == Refinery)                     %Subtract an scv that will build the building    
       minSCV.num = minSCV.num - 1;
       Refinery.completiontimes(end + 1) = t + ceil(Refinery.buildtime);                             %Increase the element of the vector````
  end
  
  
  %Storage of the data
  NewArmyValue = NewArmyValue + buildchoice.mincost + buildchoice.gascost;
  NewBuildOrder(end + 1) = buildchoice;
  NewSupplyCount(end + 1) = CurrentSupply;





      
   
t = t+1;        %Increment the time value
end


%If the new army value is greater than the previous, make it the old build
%order - the old stuff will then be the desired output
if(NewArmyValue >= OldArmyValue)
    NewArmyValue = OldArmyValue;
    NewBuildOrder = OldBuildOrder;
    NewSupplyCount = OldSupplyCount;
end


    


   
   
   
   
   
   
   
   
