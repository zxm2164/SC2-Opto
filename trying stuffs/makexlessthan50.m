function [ newx, subtracttimes ] = makexlessthan50( x )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
newx=x
subtracttimes=0
if newx>=50
    subtracttimes=subtracttimes+1
    newx=newx-50
    makexlessthan50(newx)
end

end

