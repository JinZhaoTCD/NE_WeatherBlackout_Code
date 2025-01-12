
load('Single_state_weather_event')
load('Single_state_weather_No_event')
%select outage with beyond a level of intensity
select_weather = [13 14 15 16];%16
%13-17%{'GHI (w/m2)'} {'Wind Speed (m/s)'} {'Relative Humidity (%)'} {'Temperature (degree c)'} {'Pressure (mbar)'}
intensity_type = 7;%3duration,6demandMW,7customer
thresh_hold = 0;
reserve = [];
for i = 1:length(Single_state_weather_event)
    if strcmp(class(Single_state_weather_event{i,intensity_type}),'double')==1 %&& strcmp(class(Single_state_weather_event{i,3}),'double')==1
        RES_per =  Single_state_weather_event{i,12};
        if Single_state_weather_event{i,intensity_type}>thresh_hold %& Single_state_weather_event{i,3}>0 %&& (RES_per>=10 && RES_per<20)%100000%200000
            reserve = [reserve,i];
        end
    end
end
state_weather_event = Single_state_weather_event(reserve,:);

reserve = [];
for i = 1:length(Single_state_weather_No_event)
    if strcmp(class(Single_state_weather_No_event{i,intensity_type}),'double')==1 %&& strcmp(class(state_event_cell{i,6}),'double')==1
        RES_per =  Single_state_weather_No_event{i,12};
        if Single_state_weather_No_event{i,intensity_type}>thresh_hold %&& (RES_per>=10 && RES_per<20)%500000%200000
            reserve = [reserve,i];
        end
    end
end
state_weather_No_event = Single_state_weather_No_event(reserve,:);


Single_state_a11_event = [state_weather_event;state_weather_No_event];

y1_weather = cell2mat(state_weather_event(:,select_weather));%13-17%{'GHI (w/m2)'} {'Wind Speed (m/s)'} {'Relative Humidity (%)'} {'Temperature (degree c)'} {'Pressure (mbar)'}
y1_weather = min(y1_weather, [], 2);


y2_weather = cell2mat(state_weather_No_event(:,select_weather));%13-17%{'GHI (w/m2)'} {'Wind Speed (m/s)'} {'Relative Humidity (%)'} {'Temperature (degree c)'} {'Pressure (mbar)'}
y2_weather = min(y2_weather, [], 2);

[num,~] = size(y1_weather);
law_weahter_event = [];
for i = 1:1:500
    count = length(find(y1_weather<=i/1000));
    law_weahter_event = [law_weahter_event;i,count/num];
end
[b,m,n]=unique(law_weahter_event(:,2),'stable');
temp1 = law_weahter_event(m,1);
temp2 = law_weahter_event(m,2);
law_weahter_event = [temp1,temp2];

[num,~] = size(y2_weather);
law_weahter_no_event = [];
for i = 1:1:500
    count = length(find(y2_weather<=i/1000));
    law_weahter_no_event = [law_weahter_no_event;i,count/num];
end
[b,m,n]=unique(law_weahter_no_event(:,2),'stable');
temp1 = law_weahter_no_event(m,1);
temp2 = law_weahter_no_event(m,2);
law_weahter_no_event = [temp1,temp2];

figure(1)
weather1 = law_weahter_event(:,1);
weather2 = law_weahter_event(:,2);
No_weather1 = law_weahter_no_event(:,1); 
No_weather2 = law_weahter_no_event(:,2);
%subplot(1,2,1)
plot(law_weahter_event(:,1),law_weahter_event(:,2),'b.','MarkerSize',10)
grid on
xlim([0,500])
hold on
hold on
plot([0,500],[0,1],'--')

%subplot(1,2,2)
plot(law_weahter_no_event(:,1),law_weahter_no_event(:,2),'r.','MarkerSize',10)
grid on
xlim([0,500])
hold on
plot([0,500],[0,1],'--')

figure(2)
%state_weather_event = Single_state_a11_event;
RES_per = cell2mat(state_weather_event(:,12));
weather_con = cell2mat(state_weather_event(:,select_weather));%13-17%{'GHI (w/m2)'} {'Wind Speed (m/s)'} {'Relative Humidity (%)'} {'Temperature (degree c)'} {'Pressure (mbar)'}
weather01 = [];
weather12 = [];
weather23 = [];
weather3_ = [];
for i = 1:length(RES_per)
    if RES_per(i)<10
        weather01 =[weather01;weather_con(i,:)];
    end
    if RES_per(i)>=10 && RES_per(i)<20
        weather12 =[weather12;weather_con(i,:)];
    end
    if RES_per(i)>=20 && RES_per(i)<30
        weather23 =[weather23;weather_con(i,:)];
    end
    if RES_per(i)>=30 && RES_per(i)<=40
        weather3_ =[weather3_;weather_con(i,:)];
    end  
end

weather01 = min(weather01, [], 2);
weather12 = min(weather12, [], 2);
weather23 = min(weather23, [], 2);
weather3_ = min(weather3_, [], 2);

[h,p] = ttest2(weather01,weather12,'Vartype','unequal','tail','left')%*
[h,p] = ttest2(weather12,weather23,'Vartype','unequal','tail','left')
[h,p] = ttest2(weather01,weather23,'Vartype','unequal','tail','left')%*
[h,p] = ttest2(weather23,weather3_,'Vartype','unequal','tail','left')
% 
% [p,h] = ranksum(weather01,weather12,'tail','left')
% [p,h] = ranksum(weather12,weather23,'tail','left')
% [p,h] = ranksum(weather23,weather3_,'tail','left')
% [p,h] = ranksum(weather01,weather23,'tail','left')

law_weahter01 = [];
[num,~] = size(weather01);
for i = 1:1:500
    count = length(find(weather01<=i/1000));
    law_weahter01 = [law_weahter01;i,count/num];
end
[b,m,n]=unique(law_weahter01(:,2),'stable');
temp1 = law_weahter01(m,1);
temp2 = law_weahter01(m,2);
law_weahter01 = [temp1,temp2];

law_weahter12 = [];
[num,~] = size(weather12);
for i = 1:1:500
    count = length(find(weather12<=i/1000));
    law_weahter12 = [law_weahter12;i,count/num];
end
[b,m,n]=unique(law_weahter12(:,2),'stable');
temp1 = law_weahter12(m,1);
temp2 = law_weahter12(m,2);
law_weahter12 = [temp1,temp2];

law_weahter23 = [];
[num,~] = size(weather23);
for i = 1:1:500
    count = length(find(weather23<=i/1000));
    law_weahter23 = [law_weahter23;i,count/num];
end
[b,m,n]=unique(law_weahter23(:,2),'stable');
temp1 = law_weahter23(m,1);
temp2 = law_weahter23(m,2);
law_weahter23 = [temp1,temp2];

law_weahter3_ = [];
[num,~] = size(weather3_);
for i = 1:1:500
    count = length(find(weather3_<=i/1000));
    law_weahter3_ = [law_weahter3_;i,count/num];
end
[b,m,n]=unique(law_weahter3_(:,2),'stable');
temp1 = law_weahter3_(m,1);
temp2 = law_weahter3_(m,2);
law_weahter3_ = [temp1,temp2];

w11 = law_weahter01(:,1);
w12 = law_weahter01(:,2);
w21 = law_weahter12(:,1);
w22 = law_weahter12(:,2);
w31 = law_weahter23(:,1);
w32 = law_weahter23(:,2);
w41 = law_weahter3_(:,1);
w42 = law_weahter3_(:,2);
plot(law_weahter01(:,1),law_weahter01(:,2),'g.','MarkerSize',10)
hold on
plot(law_weahter12(:,1),law_weahter12(:,2),'m.','MarkerSize',10)
hold on
plot(law_weahter23(:,1),law_weahter23(:,2),'b.','MarkerSize',10)
hold on
plot(law_weahter3_(:,1),law_weahter3_(:,2),'y.','MarkerSize',10)
grid on
hold on
plot([0,500],[0,1],'--')