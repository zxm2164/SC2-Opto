%Calculates the number of resources per second(Assume that 2 command
%centers means 1 expansion.  Those after 2 are (currently made to) not being used as
%expansions
function [Rmin Rgas Ren] = determineResources(Rmin,Rgas,Ren,minSCV,gasSCV, Mule,CommandCenter, OrbitalCommandCenter)

%If the number of mineral collecting scv's gets larger than 16, those after
%it collect slower - Mules collect at 4 resources per second
if (minSCV > 16 && minSCV <= 24  && CommandCenter == 1)
	  Rmin = (16 * 1) + ((minSCV - 16)  * .5) + (Mule * 4) + Rmin; %Approximately 1 min/per s per scv maximum, over 16 yields .9 min/per s per scv
      
%If the player has more than one Command Center,we assume that it is an expansion, and we assume that we move any
%scv over 16 total to the other expansion
elseif (minSCV > 16 && CommandCenter > 1)
      Rmin = (minSCV * 1) + (Mule * 4) + Rmin;
      
%If there is more than 16 SCV's at each command center, those after begin
%collecting at the slower rate
elseif (minSCV > 32 && CommandCenter > 1)                          %If more than 1 command center send slow collectors to the other cc's
    Rmin = (32 * 1) + ((minSCV - 32) * .5) + (Mule * 4) + Rmin;
    
%If the player has under 16 SCV's, then they collect at the maximum rate
elseif (minSCV <= 16)
	Rmin = (minSCV * 1) + (Mule * 4) + Rmin;
end


%Gas collecting SCV's collect at 1.1 gas per second
Rgas = (gasSCV * 1.1) + Rgas;                         %Gas collection rate is constant 1.1 gas per s per scv

%Energy collection from Orbitals
Ren = (OrbitalCommandCenter * .5625) + Ren;               
if Ren > 200
    Ren = 200 * OrbitalCommandCenter;
end

end




