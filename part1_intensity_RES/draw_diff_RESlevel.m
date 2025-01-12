clc,clear
storm_event = {'Severe Storm','Major Storm','Ice Storm','Thunderstorm','Tropical Storm','Winter Storm','Snow Storm','Hurricane'};
storm = {'Storm'};
wind = {'High Wind','Highwind','Wind Storm','Windstorm','Strong Wind','Heavy Wind'};
wind2 = {'Wind'};
other_weather = {'Severe Weather','Severe weather','Weather','Tropical Depression ','Heat','High Temperature','Flood','Lightning','Earthquake','Fire','Natural','Nature','Ice'};
other = {'Failure','Cyber','Terrorist','Human','physical attact','Voltage Reduction','Equipment','Vandalism','Sabotage','Operat'};

load('single_state');
load('normalize_single_state')
data = normalize_single_state(1:2156,:);%2001-2007 1:278;%2008-2014 279:1183;%2015- 1184:2156/2428

load('state_RES');
RES_pen = state_RES(48*12*0+1:48*12*20,:);%48state*12month*21years% wind,soar,wind+solar

% % 2001-2021 https://www.eia.gov/electricity/data/browser/#/topic/56?agg=0,1&geo=g&endsec=vg&linechart=ELEC.CUSTOMERS.US-ALL.A~ELEC.CUSTOMERS.US-RES.A~ELEC.CUSTOMERS.US-COM.A~ELEC.CUSTOMERS.US-IND.A&columnchart=ELEC.CUSTOMERS.US-ALL.A~ELEC.CUSTOMERS.US-RES.A~ELEC.CUSTOMERS.US-COM.A~ELEC.CUSTOMERS.US-IND.A&map=ELEC.CUSTOMERS.US-ALL.A&freq=A&start=2008&end=2021&ctype=linechart&ltype=pin&rtype=s&maptype=0&rse=0&pin=
% customer_number = [131359239 133624035 134544348 136119176 138367159 140403965 142121652 143395691	143529126	144139862	144508982	145293583	146288214	147373362	148632855	150055191	151779385	153338872	154898041	156522920	157915856];
% % 2001-2021 https://www.eia.gov/electricity/data/browser/#/topic/5?agg=0,1&geo=g&endsec=vg&linechart=ELEC.SALES.US-ALL.A~~~~~&columnchart=ELEC.SALES.US-ALL.A~ELEC.SALES.US-RES.A~ELEC.SALES.US-COM.A~ELEC.SALES.US-IND.A&map=ELEC.SALES.US-ALL.A&freq=A&start=2001&end=2021&ctype=linechart&ltype=pin&rtype=s&maptype=0&rse=0&pin=
% customer_MWh = [3394458	3465466	3493734	3547479	3660969	3669919	3764561	3733965	3596795	3754841	3749846	3694650	3724868	3764700	3758992	3762462	3723356	3859185	3811150	3717674	3794539];
% % normalize according to 2020
% temp = customer_number(20);
% for i=1:length(customer_number)
%     customer_number(i) = temp/customer_number(i);
% end
% temp = customer_MWh(20);
% for i=1:length(customer_MWh)
%     customer_MWh(i) = temp/customer_MWh(i);
% end
% 
% normalize event demand MW & customer number
% for i = length(single_state)
%     temp = single_state{i,1};
%     index = strfind(temp,'/');
%     year = str2num(temp(index(2)+1:index(2)+4));
%     month = str2num(temp(1:index(1)-1));
%     day = str2num(temp(index(1)+1:index(2)-1));
%     if strcmp(class(single_state{i,6}),'double') == 1
%         single_state{i,6} = single_state{i,6}*customer_MWh(year-2000);   
%     end
%     if strcmp(class(single_state{i,7}),'double') == 1
%         single_state{i,7} = single_state{i,7}*customer_number(year-2000);   
%     end     
% end


state_event_cell = cell(1,12);
state_No_event_cell = cell(1,12);
for i = 1:length(data)
    per = (data{i,10}+data{i,11})/data{i,12};
    data{i,12} = per*100;
    event_sign = 0;
    for j = 1:length(storm_event)
        if isempty(strfind(data{i,5},storm_event{j})) == 0
            event_sign = 1;
        end
    end
    for j = 1:length(storm)
        if isempty(strfind(data{i,5},storm{j})) == 0
            event_sign = 1;
        end
    end
    for j = 1:length(wind)
        if isempty(strfind(data{i,5},wind{j})) == 0
            event_sign = 1;
        end
    end
    for j = 1:length(wind2)
        if isempty(strfind(data{i,5},wind2{j})) == 0
            event_sign = 1;
        end
    end
    for j = 1:length(other_weather)
        if isempty(strfind(data{i,5},other_weather{j})) == 0
            event_sign = 1;
        end
    end
    if event_sign == 1
        state_event_cell = [state_event_cell;data(i,:)];
    else
        state_No_event_cell = [state_No_event_cell;data(i,:)];
    end
end
state_event_cell(1,:) = [];
state_No_event_cell(1,:) = [];

% save('state_event_cell','state_event_cell')
% save('state_No_event_cell','state_No_event_cell')

% event_cell = state_event_cell;

intensity_type = 7;%3duration,6demandMW,7customer
event_cell=cell(1,12);
for i = 1:length(state_event_cell)
    if strcmp(class(state_event_cell{i,intensity_type}),'double')==1 %&& strcmp(class(state_event_cell{i,6}),'double')==1
        if state_event_cell{i,intensity_type} >= 0%60%60*24*3%1440*5
            event_cell = [event_cell;state_event_cell(i,:)];
        end
    end
end
event_cell(1,:) = [];


No_event_cell=cell(1,12);
for i = 1:length(state_No_event_cell)
    if strcmp(class(state_No_event_cell{i,intensity_type}),'double')==1 %&& strcmp(class(state_No_event_cell{i,6}),'double')==1
        if state_No_event_cell{i,intensity_type} >= 0%60%60*24*3%1440*5
            No_event_cell = [No_event_cell;state_No_event_cell(i,:)];
        end
    end
end
No_event_cell(1,:) = [];

% event_cell = state_event_cell;
% No_event_cell = state_No_event_cell;

% figure(1)
% 
% x1 = cell2mat(event_cell(:,12));
% y1 = cell2mat(event_cell(:,intensity_type));
% year1 = [];
% time1 = [];
% for i = 1:length(event_cell)
%     temp = event_cell{i,1};
%     index = strfind(temp,'/');
%     year = str2num(temp(index(2)+1:index(2)+4));
%     month = str2num(temp(1:index(1)-1));
%     day = str2num(temp(index(1)+1:index(2)-1));
%     year1 = [year1,year];
%     time1 = [time1,(year-2001)*12+month];
% end
% 
% x2 = cell2mat(No_event_cell(:,12));
% y2 = cell2mat(No_event_cell(:,intensity_type));
% year2 = [];
% time2 = [];
% for i = 1:length(No_event_cell)
%     temp = No_event_cell{i,1};
%     index = strfind(temp,'/');
%     year = str2num(temp(index(2)+1:index(2)+4));
%     month = str2num(temp(1:index(1)-1));
%     day = str2num(temp(index(1)+1:index(2)-1));
%     year2 = [year2,year];
%     time2 = [time2,(year-2001)*12+month];
% end
% 
% plot3(time1,x1,y1,'or')
% hold on
% plot3(time2,x2,y2,'b*')
% xlabel('year')
% ylabel('RES percentage')
% if intensity_type == 3
%     zlabel('Blackout duration')
% end
% if intensity_type == 6
%     zlabel('Demand loss MW')
% end
% if intensity_type == 7
%     zlabel('Affected customer number')
% end
% grid on
% set(gca,'XTick',[0:24:240])
% %zlim([0,5000])
% 
% figure(2)
x = RES_pen(:,3)*100;
y = zeros(length(RES_pen),1);
% plot(x,y,'o')


figure(3)
subplot(1,4,1)
event_count = [];
per_event = cell2mat(event_cell(:,12));
% for s=1:10
%     count = 0;
%     for ss = 1:length(per_event)
%         if per_event(ss)<s*10 && per_event(ss)>=(s-1)*10
%             count = count + 1;
%         end       
%     end
%     event_count = [event_count,count];
% end
% plot([1:10],event_count,'-o')

for s=1:2
    count = 0;
    for ss = 1:length(per_event)
        if per_event(ss)<s*10 && per_event(ss)>=(s-1)*10
            count = count + 1;
        end       
    end
    event_count = [event_count,count];
end
% count = 0;
% for ss = 1:length(per_event)
%     if per_event(ss)<25 && per_event(ss)>=15
%         count = count + 1;
%     end
% end
% event_count = [event_count,count];
count = 0;
for ss = 1:length(per_event)
    if  per_event(ss)<30 &&per_event(ss)>=20
        count = count + 1;
    end
end
event_count = [event_count,count];
count = 0;
for ss = 1:length(per_event)
    if  per_event(ss)>=30 &&per_event(ss)<40
        count = count + 1;
    end
end
event_count = [event_count,count];
plot([1:4],event_count,'-o')

subplot(1,4,2)
no_event_count = [];
per_no_event = cell2mat(No_event_cell(:,12));
% for s=1:10
%     count = 0;
%     for ss = 1:length(per_no_event)
%         if per_no_event(ss)<s*10 && per_no_event(ss)>=(s-1)*10
%             count = count + 1;
%         end       
%     end
%     no_event_count = [no_event_count,count];
% end
% plot([1:10],no_event_count,'^-')
for s=1:2
    count = 0;
    for ss = 1:length(per_no_event)
        if per_no_event(ss)<s*10 && per_no_event(ss)>=(s-1)*10
            count = count + 1;
        end       
    end
    no_event_count = [no_event_count,count];
end
% count = 0;
% for ss = 1:length(per_no_event)
%     if per_no_event(ss)<25 && per_no_event(ss)>=15
%         count = count + 1;
%     end
% end
% no_event_count = [no_event_count,count];
count = 0;
for ss = 1:length(per_no_event)
    if per_no_event(ss)<30 && per_no_event(ss)>=20
        count = count + 1;
    end
end
no_event_count = [no_event_count,count];
count = 0;
for ss = 1:length(per_no_event)
    if per_no_event(ss)>=30 && per_no_event(ss)<40
        count = count + 1;
    end
end
no_event_count = [no_event_count,count];
plot([1:4],no_event_count,'^-')


subplot(1,4,3)
% total grid numbers under differnet RES percentage
load('state_RES_weather_cell')
grid_weather = cell2mat(state_RES_weather_cell(2:end,7:12));
grid_count = [];
grid_weather_count = [];
% for s=1:10
%     count = 0;
%     count2 = 0;
%     for ss = 1:length(x)
%         if x(ss)<s*10 && x(ss)>=(s-1)*10
%             count = count + 1;
%             count2 = count2 + grid_weather(ss,end);
%         end
%     end
%     grid_count = [grid_count,count];
%     grid_weather_count = [grid_weather_count,count2];
% end
% plot([1:10],grid_count,'*-')
% subplot(1,4,4)
% plot([1:10],grid_weather_count,'*-')

for s=1:2
    count = 0;
    count2 = 0;
    for ss = 1:length(x)
        if x(ss)<s*10 && x(ss)>=(s-1)*10
            count = count + 1;
%            count2 = count2 + grid_weather(ss,end);
        end
    end
    grid_count = [grid_count,count];
%    grid_weather_count = [grid_weather_count,count2];
end
% count = 0;
% count2 = 0;
% for ss = 1:length(x)
%     if x(ss)<25 && x(ss)>=15
%         count = count + 1;
%         count2 = count2 + grid_weather(ss,end);
%     end
% end
% grid_count = [grid_count,count];
% grid_weather_count = [grid_weather_count,count2];
count = 0;
count2 = 0;
for ss = 1:length(x)
    if x(ss)<30 && x(ss)>=20
        count = count + 1;
%        count2 = count2 + grid_weather(ss,end);
    end
end
grid_count = [grid_count,count];
%grid_weather_count = [grid_weather_count,count2];
count = 0;
count2 = 0;
for ss = 1:length(x)
    if x(ss)>=30 && x(ss)<40
        count = count + 1;
%        count2 = count2 + grid_weather(ss,end);
    end
end
grid_count = [grid_count,count];
%grid_weather_count = [grid_weather_count,count2];
plot([1:4],grid_count,'*-')
% subplot(1,4,4)
% plot([1:4],grid_weather_count,'*-')

figure(4)
plot([1:4],(event_count+no_event_count)./grid_count*100,'r*-')%,[1:10],no_event_count./grid_count,'ro-')
hold on
% figure(5)
% plot([1:4],event_count./grid_weather_count*100,'r^-')%,[1:10],no_event_count./grid_weather_count,'bo-')
% hold on
% ylabel('event occur percentage')
