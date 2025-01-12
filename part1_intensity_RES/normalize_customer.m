clc,clear

load('single_state');
data = single_state;
% normalize state affected customer number each 5,000,000、 normalized
% demand loss: percentgae%
% [~,~,CUS_number] = xlsread('state_customers_annual.xlsx');%,'Customers');
% [~,~,CUS_MWh] = xlsread('state_customersMWh_annual.xlsx');%,'Customers2');

load('CUS.mat')


for i = 1:length(data)
    temp = data{i,1};
    index = strfind(temp,'/');
    year = str2num(temp(index(2)+1:index(2)+4));
    state = data{i,9};
    if strcmp(class(data{i,7}),'double') == 1
        for j = 1:length(CUS_number)
            if isempty(strfind(CUS_number{j,3},'Total Electric Industry'))==0 && strcmp(state,CUS_number{j,2})==1 && year==CUS_number{j,1}%find year&state
                data{i,7} = data{i,7}/CUS_number{j,9}*5000000;
            end
        end
    end   
    if strcmp(class(data{i,6}),'double') == 1
        for j = 1:length(CUS_MWh)
            if isempty(strfind(CUS_MWh{j,3},'Total Electric Industry'))==0 && strcmp(state,CUS_MWh{j,2})==1 && year==CUS_MWh{j,1}%find year&state
                data{i,6} = data{i,6}/(CUS_MWh{j,9}/(365*24))*100;
            end
        end
    end
     
end
normalize_single_state = data;
save('normalize_single_state','normalize_single_state')