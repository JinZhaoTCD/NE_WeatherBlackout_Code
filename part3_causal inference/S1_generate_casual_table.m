clc,clear
State={'Alabama', 'Alaska','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','Florida','Georgia','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','MontanaNebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota','Ohio','Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina','South Dakota','Tennessee','Texas','Utah','Vermont','Virginia','Washington','West Virginia','Wisconsin','Wyoming'};
State_short48={'AL','AR','AZ','CA','CO','CT','DE','FL','GA','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY'};
cata = {'GHI','WIND','Humudity','Temperature','Pressure','outage status','type','RES pen%','duration','demand loss','customer number'};
%%
%load('Single_state_weather_event');% weather condition rare level: min(low_per,high_per)
%('Single_state_weather_event2');% weather condition percentage, compare with monthly data
%load('Single_state_weather_event3');% weather condition percentage (except pressure), compare with whole data**********cluster use this

%('Elec_region_weather_event');% weather condition percentage, compare with monthly data
%% outage status 0/1,type (weather/non-weather), RES%, duration, demand loss, customer number

load('state_weather')
load('state_event_cell')% customer numer is normalized
load('state_No_event_cell')
load('state_RES_weather_cell')
Month_31 = [1 3 5 7 8 10 12];%31days
Month_30 = [4 6 9 11];%30days


database_causal = cell(7302,4+48*11);
database_causal(2:end,1:4) =  state_weather(:,1:4);

for i=1:48
    for j = 1:11
        database_causal{1,4+(i-1)*11+j} = State_short48{i};
    end
    database_causal(2,4+(i-1)*11+1:4+i*11) = cata;
end

data_extra = state_weather(2:end,5:end);
data = cell2mat(data_extra);


data = state_weather(2:end,:);
data = cell2mat(data);
[line,column] = size(data);
weather_percent = zeros(size(data)); %weather conditions in percentages
weather_percent(:,1:4) = data(:,1:4);
weather_rarity = weather_percent;
for i = 5:column
    for j = 1:line
        low_per = length(find(data(:,i)<=data(j,i)))/line;
        high_per = length(find(data(:,i)>=data(j,i)))/line;       
        weather_percent(j,i) = low_per;            
        weather_rarity(j,i) = min(low_per,high_per);
    end
end

% add weather condition
for i = 1:48
    database_causal(3:end,4+(i-1)*11+1:4+(i-1)*11+5) = num2cell(weather_rarity(:,4+(i-1)*5+1:4+i*5));   
end

% add RES penetration
for i = 2:length(state_RES_weather_cell)
    state_name = state_RES_weather_cell{i,1};
    year = state_RES_weather_cell{i,2};
    month = state_RES_weather_cell{i,3};
    RES_pen = state_RES_weather_cell{i,6};
    idx1 = find(strcmp(database_causal(1,:),state_name));
    
    temp_year = cell2mat(database_causal(3:end,1));
    temp_month = cell2mat(database_causal(3:end,2));   
    idx2 = find((temp_year==year)&(temp_month==month));
    
    temp_res = ones(size(idx2))*RES_pen;
    
    database_causal(2+idx2,idx1(8)) = num2cell(temp_res); 
end


% add outage event condition
for i = 1:48
    database_causal(3:end,4+(i-1)*11+6) = num2cell(zeros(7300,1));
    database_causal(3:end,4+(i-1)*11+7) = num2cell(zeros(7300,1));
end


for i = 1:length(state_event_cell)
    temp = state_event_cell{i,1};
    index = strfind(temp,'/');
    year = str2num(temp(index(2)+1:index(2)+4));
    month = str2num(temp(1:index(1)-1));
    day = str2num(temp(index(1)+1:index(2)-1));  
    seq_time = 0;
    seq_time = seq_time + (year-2001)*365;% + fix((year-2001)/4);%add 366 days conditions
    for count_mon = 1:month-1
        if isempty(find(Month_31==count_mon)) == 0
            seq_time = seq_time + 31;
        end
        if isempty(find(Month_30==count_mon)) == 0
            seq_time = seq_time + 30;
        end
        if count_mon == 2
            seq_time = seq_time + 28; %the data take all the feb. as 28
        end
    end
    seq_time = seq_time + day;
    state_name = state_event_cell{i,9};
    
    idx = find(strcmp(database_causal(1,:),state_name));
    
    database_causal{seq_time+2,idx(6)} = 1;
    database_causal{seq_time+2,idx(7)} = 1;
    database_causal(seq_time+2,idx(9)) = state_event_cell(i,3);
    database_causal(seq_time+2,idx(10)) = state_event_cell(i,6);
    database_causal(seq_time+2,idx(11)) = state_event_cell(i,7);
end


for i = 1:length(state_No_event_cell)
    temp = state_No_event_cell{i,1};
    index = strfind(temp,'/');
    year = str2num(temp(index(2)+1:index(2)+4));
    month = str2num(temp(1:index(1)-1));
    day = str2num(temp(index(1)+1:index(2)-1));  
    seq_time = 0;
    seq_time = seq_time + (year-2001)*365;% + fix((year-2001)/4);%add 366 days conditions
    for count_mon = 1:month-1
        if isempty(find(Month_31==count_mon)) == 0
            seq_time = seq_time + 31;
        end
        if isempty(find(Month_30==count_mon)) == 0
            seq_time = seq_time + 30;
        end
        if count_mon == 2
            seq_time = seq_time + 28; %the data take all the feb. as 28
%             if mod(year,4) == 0%sepcial february
%                 seq_time = seq_time + 29;
%             else
%                 seq_time = seq_time + 28;
%             end
        end
    end
    seq_time = seq_time + day;
    state_name = state_No_event_cell{i,9};
    idx = find(strcmp(database_causal(1,:),state_name));
    
    database_causal{seq_time+2,idx(6)} = 1;
    database_causal{seq_time+2,idx(7)} = 0;
    database_causal(seq_time+2,idx(9)) = state_No_event_cell(i,3);
    database_causal(seq_time+2,idx(10)) = state_No_event_cell(i,6);
    database_causal(seq_time+2,idx(11)) = state_No_event_cell(i,7);
end

database_casual_rarity = database_causal;
% save('database_causal','database_causal')
save('database_casual_rarity','database_casual_rarity')

% select_weather = 14;%[13 14 15 16];%16
% %13-17%{'GHI (w/m2)'} {'Wind Speed (m/s)'} {'Relative Humidity (%)'} {'Temperature (degree c)'} {'Pressure (mbar)'}
% intensity_type = 7;%3duration,6demandMW,7customer
% thresh_hold = 0;
% reserve = [];
% for i = 1:length(Single_state_weather_event)
%     if strcmp(class(Single_state_weather_event{i,intensity_type}),'double')==1 %&& strcmp(class(Single_state_weather_event{i,3}),'double')==1
%         RES_per =  Single_state_weather_event{i,12};
%         if Single_state_weather_event{i,intensity_type}>thresh_hold %& Single_state_weather_event{i,3}>0 %&& (RES_per>=10 && RES_per<20)%100000%200000
%             reserve = [reserve,i];
%         end
%     end
% end
% state_weather_event = Single_state_weather_event(reserve,:);

