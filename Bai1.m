
clear; 
close all;
load mtlb;
file = ['01MDA','02FVA','03MAB','04MHB','05MVB','06FTB','07FTC','08MLD'];
for i = 1:8
    figure(i); draw(file((i-1)*5+1:5*i)); 
end
