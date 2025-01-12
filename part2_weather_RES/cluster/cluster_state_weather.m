%cluster customer,time,weather to find RES percentage condition
clc,clear


load('Single_state_weather_event3');% weather condition percentage (except pressure), compare with whole data**********use this
Single_state_weather_event = Single_state_weather_event3;

intensity_type = 7;%3duration,6demandMW,7customer
reserve = [];
for i = 1:length(Single_state_weather_event)
    if strcmp(class(Single_state_weather_event{i,intensity_type}),'double')==1 && strcmp(class(Single_state_weather_event{i,3}),'double')==1
        select_idx =  Single_state_weather_event{i,12};
        if Single_state_weather_event{i,intensity_type}>0 & Single_state_weather_event{i,3}>0 %&& (RES_per>=10 && RES_per<20)%100000%200000
            reserve = [reserve,i];
        end
    end
end
state_weather_event = Single_state_weather_event(reserve,:);

y1_weather = cell2mat(state_weather_event(:,13:17));%13-17%{'GHI (w/m2)'} {'Wind Speed (m/s)'} {'Relative Humidity (%)'} {'Temperature (degree c)'} {'Pressure (mbar)'}

y1_weather = min(y1_weather, [], 2);
cluster_just_weather_data3 = cell2mat(state_weather_event(:,13:16));
% csvwrite('cluster_just_weather_data3.csv',cluster_just_weather_data3)


cluster_num = 8;
event_label = csvread('event_just_weather_label3.csv');%csvread('event_just_weather_label2.csv');%cluster4
[len,~] = size(event_label);
Cluster_event1 = [];
Cluster_event2 = [];
Cluster_event3 = [];
Cluster_event4 = [];
Cluster_event5 = [];
Cluster_event6 = [];
Cluster_event7 = [];
Cluster_event8 = [];
RES_per1 = [];
RES_per2 = [];
RES_per3 = [];
RES_per4 = [];
RES_per5 = [];
RES_per6 = [];
RES_per7 = [];
RES_per8 = [];
temp_event1 = cell(1,17);
temp_event2 = cell(1,17);
temp_event3 = cell(1,17);
temp_event4 = cell(1,17);
temp_event5 = cell(1,17);
temp_event6 = cell(1,17);
temp_event7 = cell(1,17);
temp_event8 = cell(1,17);
for i = 1:len
    tem_cell = cluster_just_weather_data3(i,:);%cluster_state_weather_data(i,:);
    if event_label(i) == 0
        Cluster_event1 = [Cluster_event1;tem_cell];
        RES_per1 = [RES_per1;state_weather_event{i,12}];
        temp_event1 = [temp_event1;state_weather_event(i,:)];
    end
    if event_label(i) == 1
        Cluster_event2 = [Cluster_event2;tem_cell];
        RES_per2 = [RES_per2;state_weather_event{i,12}];
        temp_event2 = [temp_event2;state_weather_event(i,:)];
    end
    if event_label(i) == 2
        Cluster_event3 = [Cluster_event3;tem_cell];
        RES_per3 = [RES_per3;state_weather_event{i,12}];
        temp_event3 = [temp_event3;state_weather_event(i,:)];
    end
    if event_label(i) == 3
        Cluster_event4 = [Cluster_event4;tem_cell];
        RES_per4 = [RES_per4;state_weather_event{i,12}];
        temp_event4 = [temp_event4;state_weather_event(i,:)];
    end
    if event_label(i) == 4
        Cluster_event5 = [Cluster_event5;tem_cell];
        RES_per5 = [RES_per5;state_weather_event{i,12}];
        temp_event5 = [temp_event5;state_weather_event(i,:)];
    end    
    if event_label(i) == 5
        Cluster_event6 = [Cluster_event6;tem_cell];
        RES_per6 = [RES_per6;state_weather_event{i,12}];
        temp_event6 = [temp_event6;state_weather_event(i,:)];
    end
    if event_label(i) == 6
        Cluster_event7 = [Cluster_event7;tem_cell];
        RES_per7 = [RES_per7;state_weather_event{i,12}];
        temp_event7 = [temp_event7;state_weather_event(i,:)];
    end
    if event_label(i) == 7
        Cluster_event8 = [Cluster_event8;tem_cell];
        RES_per8 = [RES_per8;state_weather_event{i,12}];
        temp_event8 = [temp_event8;state_weather_event(i,:)];
    end
end
temp_event1(1,:) = [];
temp_event2(1,:) = [];
temp_event3(1,:) = [];
temp_event4(1,:) = [];
temp_event5(1,:) = [];
temp_event6(1,:) = [];
temp_event7(1,:) = [];
temp_event8(1,:) = [];


figure(1)
for j = 1:cluster_num
    if j == 1
        Cluster_event = Cluster_event1;
    end
    if j == 2
        Cluster_event = Cluster_event2;
    end
    if j == 3
        Cluster_event = Cluster_event3;
    end
    if j == 4
        Cluster_event = Cluster_event4;
    end
    if j == 5
        Cluster_event = Cluster_event5;
    end
    if j == 6
        Cluster_event = Cluster_event6;
    end
    if j == 7
        Cluster_event = Cluster_event7;
    end
    if j == 8
        Cluster_event = Cluster_event8;
    end
%%     Cluster_event(:,3) = Cluster_event(:,3)*10000;
if j == 1 || j == 3 || j == 6  || j == 8
    mean(Cluster_event)
    plot3(Cluster_event(:,1),Cluster_event(:,2),Cluster_event(:,3),'o')
hold on
grid on
% subplot(1,3,1)
% plot(Cluster_event(:,1),Cluster_event(:,3),'o')
% hold on
% grid on
% subplot(1,3,2)
% plot(Cluster_event(:,1),Cluster_event(:,4),'o')
% hold on
% grid on
% subplot(1,3,3)
% plot(Cluster_event(:,3),Cluster_event(:,4),'o')
% hold on
% grid on
end

end
% xlabel('outage time')
% ylabel('affected customers')
% zlabel('weather rare percentage')
% xlabel('GHI')
% ylabel('Wind speed')
% zlabel('Humidity')
xlabel('Wind speed')
ylabel('Humidity')
zlabel('Tempurature')


%figure(2)
index = 7;
dry_summer = [];
other_cus = [];
for j = 1:cluster_num
    subplot(1,cluster_num,j)
    if j == 1
        select_idx = cell2mat(temp_event1(:,index));
    end
    if j == 2
        select_idx = cell2mat(temp_event2(:,index));
    end
    if j == 3
        select_idx = cell2mat(temp_event3(:,index));
    end
    if j == 4
        select_idx = cell2mat(temp_event4(:,index));
    end
    if j == 5
        select_idx = cell2mat(temp_event5(:,index));
    end
    if j == 6
        select_idx = cell2mat(temp_event6(:,index));
    end
    if j == 7
        select_idx = cell2mat(temp_event7(:,index));
    end
    if j == 8
        select_idx = cell2mat(temp_event8(:,index));
    end
    mean(select_idx)%median(select_idx)%mean(select_idx)
%     thret = prctile(select_idx, [2,98]);
%     tem_indx = find(select_idx>=thret(1) & select_idx<=thret(2));
%     mean(select_idx(tem_indx))
    if j == 6 || j == 3 || j == 8 || j == 1
        dry_summer = [dry_summer;select_idx];
    else
        other_cus = [other_cus;select_idx];
    end
    %boxplot(select_idx)
end
[h,p] = ttest2(other_cus,dry_summer,'Vartype','unequal','tail','left')%*

%figure(3)
index = 3;

storm = [];
other_dur = [];
for j = 1:cluster_num
    subplot(1,cluster_num,j)
    if j == 1
        select_idx = cell2mat(temp_event1(:,index));
    end
    if j == 2
        select_idx = cell2mat(temp_event2(:,index));
    end
    if j == 3
        select_idx = cell2mat(temp_event3(:,index));
    end
    if j == 4
        select_idx = cell2mat(temp_event4(:,index));
    end
    if j == 5
        select_idx = cell2mat(temp_event5(:,index));
    end
    if j == 6
        select_idx = cell2mat(temp_event6(:,index));
    end
    if j == 7
        select_idx = cell2mat(temp_event7(:,index));
    end
    if j == 8
        select_idx = cell2mat(temp_event8(:,index));
    end
    
    if j == 8 %|| j == 8
        storm = [storm;select_idx];
    else
        other_dur = [other_dur;select_idx];
    end
    
    mean(select_idx);
%     thret = prctile(select_idx, [2,98]);
%      tem_indx = find(select_idx>=thret(1) || select_idx<=thret(2));
%     mean(select_idx(tem_indx))
   % boxplot(select_idx);
end

[h,p] = ttest2(other_dur,storm,'Vartype','unequal','tail','left')%*

%figure(4)
select_res = [];
other_res = [];
for j = 1:cluster_num
    subplot(1,cluster_num,j)
    if j == 1
        select_idx = RES_per1;
    end
    if j == 2
        select_idx = RES_per2;
    end
    if j == 3
        select_idx = RES_per3;
    end
    if j == 4
        select_idx = RES_per4;
    end
    if j == 5
        select_idx = RES_per5;
    end
    if j == 6
        select_idx = RES_per6;
    end
    if j == 7
        select_idx = RES_per7;
    end
    if j == 8
        select_idx = RES_per8;
    end
    
    if j == 3%1 || j == 8 || j == 3 || j == 6
        select_res = [select_res;select_idx];
    else
        other_res = [other_res;select_idx];
    end
    mean(select_idx);
%     thret = prctile(select_idx, [2,98]);
%      tem_indx = find(select_idx>=thret(1) || select_idx<=thret(2));
%     mean(select_idx(tem_indx))
    %boxplot(select_idx);
end
[h,p] = ttest2(other_res,select_res,'Vartype','unequal','tail','left')%*
[p,h] = ranksum(other_res,select_res,'tail','left')
