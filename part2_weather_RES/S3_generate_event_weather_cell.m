clc,clear

%%
%load('Single_state_weather_event');% weather condition rare level: min(low_per,high_per)
%('Single_state_weather_event2');% weather condition percentage, compare with monthly data
%load('Single_state_weather_event3');% weather condition percentage (except pressure), compare with whole data**********cluster use this

%('Elec_region_weather_event');% weather condition percentage, compare with monthly data
%%

load('state_weather')
load('state_event_cell')% customer numer is normalized
load('state_No_event_cell')
load('Elec_region_weather')
Month_31 = [1 3 5 7 8 10 12];%31days
Month_30 = [4 6 9 11];%30days

set_confidence = [1 99];

%----------calculate < or > x% using whole data scale----------------%
data_extra = state_weather(2:end,5:end);
data = cell2mat(data_extra);
thre_record = prctile(data, set_confidence);

data = state_weather(2:end,:);
data = cell2mat(data);
[line,column] = size(data);
abnormal_day = zeros(size(data));%weather conditions in 0/1(beyond threshold)
weather_percent = zeros(size(data)); %weather conditions in percentages
abnormal_day(:,1:4) = data(:,1:4);
weather_percent(:,1:4) = data(:,1:4);
for i = 5:column
    index_l = find(data(:,i)<thre_record(1,i-4));
    index_h = find(data(:,i)>thre_record(2,i-4));
    abnormal_day(index_h,i) = 1;
    abnormal_day(index_l,i) = -1;
    for j = 1:line
        low_per = length(find(data(:,i)<=data(j,i)))/line;
        high_per = length(find(data(:,i)>=data(j,i)))/line;
        weather_percent(j,i) = min(low_per,high_per);
%         weather_percent(j,i) = low_per;
    end
end

%------------------ calculate < or > x% using monthly data scale-------------------%
% data = state_weather(2:end,:);
% data = cell2mat(data);
% [line,column] = size(data);
% abnormal_day = zeros(size(data));%weather conditions in 0/1(beyond threshold)
% weather_percent = zeros(size(data)); %weather conditions in percentages
% abnormal_day(:,1:4) = data(:,1:4);
% weather_percent(:,1:4) = data(:,1:4);
% monthly_thre = [];%12*2,48*5
% for mon = 1:12
%     temp_monthly_data = [];
%     for i = 1:line
%         if data(i,2) == mon
%            temp_monthly_data = [temp_monthly_data;data(i,5:end)];
%         end        
%     end
%     monthly_thre = [monthly_thre; prctile(temp_monthly_data, set_confidence)];
%     % organize weather percentage
%     [base_num,~] = size(temp_monthly_data);
%     for i = 1:line
%         if weather_percent(i,2) == mon
%             for j = 5:column
%                 low_per = length(find(temp_monthly_data(:,j-4)<=data(i,j)))/base_num;
%                 high_per = length(find(temp_monthly_data(:,j-4)>=data(i,j)))/base_num;
%                 weather_percent(i,j) = min(low_per,high_per);
%                 %weather_percent(i,j) = low_per;
%             end
%         end
%     end
% end
% for i = 1:line
%     for j = 5:column
%         % lower than low threshold
%         mon = data(i,2);
%         if data(i,j) < monthly_thre(mon*2-1,j-4)
%             abnormal_day(i,j) = -1;
%         end
%         % higher tahn high threshold
%         if data(i,j) > monthly_thre(mon*2,j-4)
%             abnormal_day(i,j) = 1;
%         end        
%     end
% end
%--------------------------------------------------------------------------------------%

abs_abnormal = abnormal_day;
temp_data = abs(abnormal_day(:,5:end));
abs_abnormal(:,5:end) = temp_data;

%---------------orginize single state event weather---------------------%
Single_state_weather_event = cell(length(state_event_cell),17);
Single_state_weather_event(:,1:12) = state_event_cell;
% Single_state_weather_event2 = cell(length(state_event_cell),17);
% Single_state_weather_event2(:,1:12) = state_event_cell;
% Single_state_weather_event3 = cell(length(state_event_cell),17);
% Single_state_weather_event3(:,1:12) = state_event_cell;
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
    idx = find(strcmp(state_weather(1,:),state_name));
    Single_state_weather_event(i,13:17) = num2cell(weather_percent(seq_time,idx));
%     Single_state_weather_event2(i,13:17) = num2cell(weather_percent(seq_time,idx));
%     Single_state_weather_event3(i,13:17) = num2cell(weather_percent(seq_time,idx));
end
%save('Single_state_weather_event','Single_state_weather_event')
% save('Single_state_weather_event2','Single_state_weather_event2')
% save('Single_state_weather_event3','Single_state_weather_event3')

Single_state_weather_No_event = cell(length(state_No_event_cell),17);
Single_state_weather_No_event(:,1:12) = state_No_event_cell;
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
    idx = find(strcmp(state_weather(1,:),state_name));
    Single_state_weather_No_event(i,13:17) = num2cell(weather_percent(seq_time,idx));
end
%save('Single_state_weather_No_event','Single_state_weather_No_event')


