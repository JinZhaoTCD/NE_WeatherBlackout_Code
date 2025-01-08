clc,clear
storm_event = {'Severe Storm','Major Storm','Ice Storm','Thunderstorm','Tropical Storm','Winter Storm','Snow Storm','Hurricane'};
storm = {'Storm'};
wind = {'High Wind','Highwind','Wind Storm','Windstorm','Strong Wind','Heavy Wind'};
wind2 = {'Wind'};
other_weather = {'Severe Weather','Severe weather','Weather','Tropical Depression ','Heat','High Temperature','Flood','Lightning','Earthquake','Fire','Natural','Nature','Ice'};
other = {'Failure','Cyber','Terrorist','Human','physical attact','Voltage Reduction','Equipment','Vandalism','Sabotage','Operat'};

load('normalize_single_state')

data = normalize_single_state(1:2156,:);%2001-2007 1:278;%2008-2014 279:1183;%2015-2020 1184:2156

intensity_type = 7;%3duration,6demandMW,7customer
total_event=cell(1,12);
for i = 1:length(data)
    if strcmp(class(data{i,intensity_type}),'double')==1 %&& strcmp(class(data{i,3}),'double')==1
        if data{i,intensity_type}>0 & isempty(data(i,intensity_type))==0 %& data{i,3}>0 & isempty(data(i,3))==0
            total_event = [total_event;data(i,:)];
        end
    end
end
total_event(1,:) = [];

weather_event = cell(1,12);
No_weather_event = cell(1,12);
for i = 1:length(total_event)
    per = (total_event{i,10}+total_event{i,11})/total_event{i,12};
    total_event{i,12} = per*100;
    event_sign = 0;
    for j = 1:length(storm_event)
        if isempty(strfind(total_event{i,5},storm_event{j})) == 0
            event_sign = 1;
        end
    end
    for j = 1:length(storm)
        if isempty(strfind(total_event{i,5},storm{j})) == 0
            event_sign = 1;
        end
    end
    for j = 1:length(wind)
        if isempty(strfind(total_event{i,5},wind{j})) == 0
            event_sign = 1;
        end
    end
    for j = 1:length(wind2)
        if isempty(strfind(total_event{i,5},wind2{j})) == 0
            event_sign = 1;
        end
    end
    for j = 1:length(other_weather)
        if isempty(strfind(total_event{i,5},other_weather{j})) == 0
            event_sign = 1;
        end
    end
    if event_sign == 1
        weather_event = [weather_event;total_event(i,:)];
    else
        No_weather_event = [No_weather_event;total_event(i,:)];
    end
end
weather_event(1,:) = [];
No_weather_event(1,:) = [];
weather_event_inten = cell2mat(weather_event(:,intensity_type));
No_weather_event_inten = cell2mat(No_weather_event(:,intensity_type));

[h,p] = ttest2(No_weather_event_inten,weather_event_inten,'Vartype','unequal','tail','left')
[p,h] = ranksum(No_weather_event_inten,weather_event_inten,'tail','left')

% [h,p] = ttest2(weather_event_inten,No_weather_event_inten,'Vartype','unequal','tail','left')
% [p,h] = ranksum(weather_event_inten,No_weather_event_inten,'tail','left')

full_event_inten = No_weather_event_inten;
[num,~] = size(full_event_inten);
power_law_total = [];
for j = 100:100:8000000%10:10:100000%0.1:0.01:370%100:100:8000000
    count = length(find(full_event_inten>=j));
    if j == 100%10%0.1%100
        power_law_total = [power_law_total;j,count/num];
    end
    if j > 100%10%0.1%100
        if count/num == power_law_total(end,2)
           power_law_total(end,1) = j; 
        else
           power_law_total = [power_law_total;j,count/num];
        end
    end
end

[num,~] = size(weather_event_inten);
power_law_weahter = [];
for j = 100:100:8000000%100:100:8000000%10:10:100000%0.1:0.01:370%100:100:8000000
    count = length(find(weather_event_inten>=j));
    if j == 100
        power_law_weahter = [power_law_weahter;j,count/num];
    end
    if j > 100
        if count/num == power_law_weahter(end,2)
            power_law_weahter(end,1) = j;
        else
            power_law_weahter = [power_law_weahter;j,count/num];
        end
    end
end



figure(1)

x = (power_law_total(:,1));%log10
y = (power_law_total(:,2));
x_w = (power_law_weahter(:,1));
y_w = (power_law_weahter(:,2));

loglog(x,y,'.r','markersize',15);
hold on
loglog(x_w,y_w,'.b','markersize',15)

title('log-log plot')
xlabel('Affected customer number')%('Blackout time (min)')
ylabel('percentage of outage larger than x')

% loglog([10^2.25,10^2.25],[10^(-3.5),1],'--');
% xlim([10^(-1) 10^(3)])
% ylim([10^(-3) 1])

% % demand loss
% x_p = x(66:end);
% y_p = y(66:end);
% x_w_p = x_w(64:end);
% y_w_p = y_w(64:end);
% %affacted customer
% x_p = x(40:end);
% y_p = y(40:end);
% x_w_p = x_w(252:end);
% y_w_p = y_w(252:end);

%cftool

%% differnet RES percentage
weather_event = total_event;
%%
weather_event01 = cell(1,12);
weather_event12 = cell(1,12);
weather_event23 = cell(1,12);
weather_event3_ = cell(1,12);
for i =1:length(weather_event)
    if weather_event{i,12} < 10
        weather_event01 =[weather_event01;weather_event(i,:)];
    end
    if weather_event{i,12}>=10 && weather_event{i,12}<20
        weather_event12 =[weather_event12;weather_event(i,:)];
    end
    if weather_event{i,12}>=20 && weather_event{i,12}<30
        weather_event23 =[weather_event23;weather_event(i,:)];
    end
    if weather_event{i,12} >= 30 && weather_event{i,12} < 40
        weather_event3_ =[weather_event3_;weather_event(i,:)];
    end  
end
weather_event01(1,:) = [];
weather_event12(1,:) = [];
weather_event23(1,:) = [];
weather_event3_(1,:) = [];
weather_event_inten01 = cell2mat(weather_event01(:,intensity_type));
weather_event_inten12 = cell2mat(weather_event12(:,intensity_type));
weather_event_inten23 = cell2mat(weather_event23(:,intensity_type));
weather_event_inten3_ = cell2mat(weather_event3_(:,intensity_type));


thre_value = 100000;
RES1_L = weather_event_inten01(find(weather_event_inten01>=thre_value));
RES2_L = weather_event_inten12(find(weather_event_inten12>=thre_value));
RES3_L = weather_event_inten23(find(weather_event_inten23>=thre_value));
RES4_L = weather_event_inten3_(find(weather_event_inten3_>=thre_value));


power_law_weahter01 = [];
power_law_weahter12 = [];
power_law_weahter23 = [];
power_law_weahter3_ = [];
for j = 100:100:8000000%0.1:0.01:370%10:10:100000%100:100:8000000
    count01 = length(find(weather_event_inten01>=j));
    count12 = length(find(weather_event_inten12>=j));
    count23 = length(find(weather_event_inten23>=j));
    count3_ = length(find(weather_event_inten3_>=j));
    if j == 100 || j == 200%j == 10 || j == 20(for duration)%0.1 || j == 0.11(for demand)%j == 100 || j == 200(for customer)
        power_law_weahter01 = [power_law_weahter01;j,count01/length(weather_event01)];
        power_law_weahter12 = [power_law_weahter12;j,count12/length(weather_event12)];
        power_law_weahter23 = [power_law_weahter23;j,count23/length(weather_event23)];
        power_law_weahter3_ = [power_law_weahter3_;j,count3_/length(weather_event_inten3_)];
    end
    if j > 200%20%0.11%200
        if count01/length(weather_event01) == power_law_weahter01(end,2)%delete repeated elements and reserve the last one
            power_law_weahter01(end,1) = j;
        else
            power_law_weahter01 = [power_law_weahter01;j,count01/length(weather_event01)];
        end
        if count12/length(weather_event12) == power_law_weahter12(end,2)
            power_law_weahter12(end,1) = j;
        else
            power_law_weahter12 = [power_law_weahter12;j,count12/length(weather_event12)];
        end
        if count23/length(weather_event23) == power_law_weahter23(end,2)
            power_law_weahter23(end,1) = j;
        else
            power_law_weahter23 = [power_law_weahter23;j,count23/length(weather_event23)];
        end
        if count3_/length(weather_event_inten3_) == power_law_weahter3_(end,2)
            power_law_weahter3_(end,1) = j;
        else
            power_law_weahter3_ = [power_law_weahter3_;j,count3_/length(weather_event_inten3_)];
        end
    end
end


x_w01 = (power_law_weahter01(:,1));
y_w01 = (power_law_weahter01(:,2));
x_w12 = (power_law_weahter12(:,1));
y_w12 = (power_law_weahter12(:,2));
x_w23 = (power_law_weahter23(:,1));
y_w23 = (power_law_weahter23(:,2));
x_w3_ = (power_law_weahter3_(:,1));
y_w3_ = (power_law_weahter3_(:,2));

%cftool

figure(2)


loglog(x_w01,y_w01,'.g','markersize',15);
hold on
loglog(x_w12,y_w12,'.m','markersize',15);
hold on
loglog(x_w23,y_w23,'.b','markersize',15);
hold on
loglog(x_w3_,y_w3_,'.y','markersize',15);


title('log-log plot')
xlabel('Affected customer number')%('Blackout time (min)')
ylabel('Percentage for outage larger than x')




