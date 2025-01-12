clc,clear
load('normalize_single_state')
data = normalize_single_state(1:2156,:);%2001-2007 1:278;%2008-2014 279:1183;%2015-2020 1184:2156
%inten_type = 7;%3duration,6demandMW,7customer

for loop_f = 1:3
    if loop_f == 1
        inten_type = 7;
    end
    if loop_f == 2
        inten_type = 6;
    end
    if loop_f == 3
        inten_type = 3;
    end
total_event=cell(1,12);
for i = 1:length(data)
    if strcmp(class(data{i,inten_type}),'double')==1 %&& strcmp(class(state_event_cell{i,6}),'double')==1
        if data{i,inten_type}>0 & isempty(data(i,inten_type))==0
            total_event = [total_event;data(i,:)];
        end
    end
end
total_event(1,:) = [];
Delet_num = [];
for i = 1:length(total_event)
    per = (total_event{i,10}+total_event{i,11})/total_event{i,12};
    total_event{i,12} = per*100;
    if total_event{i,12} >= 40
        Delet_num = [Delet_num,i];
    end
end
total_event(Delet_num,:) = [];

rng('shuffle');
[num,~] = size(total_event);
sample_num = 1000;
record_chance = [];
for repeat = 1:10000
    pair = [randi(num,sample_num,1),randi(num,sample_num,1)];
    diff_res_pair = [];
    for i = 1:sample_num
        RES1 = fix(total_event{pair(i,1),12}/10)+1;%total_event{pair(i,1),12};%fix(total_event{pair(i,1),12}/10)+1;
        RES2 = fix(total_event{pair(i,2),12}/10)+1;%total_event{pair(i,2),12};%fix(total_event{pair(i,2),12}/10)+1;
        if RES1 ~= RES2%abs(RES1-RES2)>1%RES1 ~= RES2
            diff_res_pair = [diff_res_pair;pair(i,:)];
        end
    end
    [diff_num,~] = size(diff_res_pair);
    count = 0;
    for i = 1:diff_num
        RES1 = fix(total_event{diff_res_pair(i,1),12}/10)+1;%total_event{diff_res_pair(i,1),12};%fix(total_event{diff_res_pair(i,1),12}/10)+1;
        RES2 = fix(total_event{diff_res_pair(i,2),12}/10)+1;%total_event{diff_res_pair(i,2),12};%fix(total_event{diff_res_pair(i,2),12}/10)+1;
        RES1_inten = total_event{diff_res_pair(i,1),inten_type};
        RES2_inten = total_event{diff_res_pair(i,2),inten_type};
        if RES1<RES2 && RES1_inten>RES2_inten
            count = count+1;
        end
        if RES1>RES2 && RES1_inten<RES2_inten
            count = count+1;
        end
    end
    record_chance = [record_chance,count/diff_num];
end
    if loop_f == 1
        record_chance1 = record_chance;
    end
    if loop_f == 2
        record_chance2 = record_chance;
    end
    if loop_f == 3
        record_chance3 = record_chance;
    end
end
figure(1)
% record_chance3 = record_chance;
% boxplot(record_chance)
boxplot([record_chance1',record_chance2',record_chance3'])
hold on
plot(1, mean(record_chance1),'og')
hold on
plot(2, mean(record_chance2),'og')
hold on
plot(3, mean(record_chance3),'og')
ylim([0.5,0.8])
% length(find(record_chance>0.5))/5000
% figure(2)
% histogram(record_chance,500);
