clc,clear
% defination of abonormal date: one of the five weather status is beyond 1% or99%
% In Abbre. order
State_short48={'AL','AR','AZ','CA','CO','CT','DE','FL','GA','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY'};

load('state_RES')% state follows Abbre. order
state_RES_per = state_RES(1:12*48*20,3);%2001-2020

load('state_weather')%{'GHI (w/m2)'} {'Wind Speed (m/s)'} {'Relative Humidity (%)'} {'Temperature (degree c)'} {'Pressure (mbar)'}
% state_num = find(strcmp(State_short48,'PA'));

thre_record = [];
for state_num = 1:48
    data_extra = state_weather(2:end,5+5*(state_num-1):9+5*(state_num-1));
    data = cell2mat(data_extra);
    thre_record = [thre_record, prctile(data,[1 99])];
%     for i = 1:5
%         subplot(1,5,i)
%         boxplot(data(:,i))
%         thre_record(2,i+(state_num-1)*5) = prctile(data(:,i),90);
%         thre_record(1,i+(state_num-1)*5) = prctile(data(:,i),10);
%     end
end

data = state_weather(2:end,:);
data = cell2mat(data);
[line,column] = size(data);
abnormal_day = zeros(size(data));
abnormal_day(:,1:4) = data(:,1:4);
for i = 5:column
    index_l = find(data(:,i)<thre_record(1,i-4));
    index_h = find(data(:,i)>thre_record(2,i-4));
    abnormal_day(index_h,i) = 1;
    abnormal_day(index_l,i) = -1;
end

abs_abnormal = abnormal_day;
temp_data = abs(abnormal_day(:,5:end));
abs_abnormal(:,5:end) = temp_data;

mon_abnormal_count = [];
mon_abnormal_date = [];
for year = 2001:2020
    idx_s = find(abs_abnormal(:,1)==year, 1, 'first');
    idx_e = find(abs_abnormal(:,1)==year, 1, 'last');
    temp_data = abs_abnormal(idx_s:idx_e,:);
    for mon = 1:12
        idx_s2 = find(temp_data(:,2)==mon, 1, 'first');
        idx_e2 = find(temp_data(:,2)==mon, 1, 'last');
        temp_mon_data = temp_data(idx_s2:idx_e2,5:end);
        temp_total_state_data = [];
        for state_num = 1:48
            temp_state_date = [];
            for idx_date = idx_s2:idx_e2
                if sum(temp_data(idx_date,4+(state_num-1)*5+1:4+state_num*5)) >= 1
                    temp_state_date = [temp_state_date;1];
                else
                    temp_state_date = [temp_state_date;0];
                end
            end
            mon_abnormal_date = [mon_abnormal_date;sum(temp_state_date)];            
        end
        temp_mon_state = sum(temp_mon_data);
        for state_num = 1:48
            mon_abnormal_count = [mon_abnormal_count; temp_mon_state((state_num-1)*5+1:state_num*5)];
        end
    end
end

state_RES_weather = [state_RES(1:12*48*20,:)*100,mon_abnormal_count,mon_abnormal_date];
state_year = [];
state_mon = [];
for year = 1:20
    state_year = [state_year;ones(12*48,1)*(2000+year)];
    for mon = 1:12
        state_mon = [state_mon;ones(48,1)*mon];
    end
end

state_name = cell(1,1);
for mon = 1:12*20
    state_name = [state_name;State_short48'];
end
state_name(1)=[];

% state_RES_weather_cell = cell(12*48*20,1);
head = cell(1,11);
head{1,1} = 'state_name';
head{1,2} = 'year';
head{1,3} = 'month';
head{1,4} = 'wind penetration (%)';
head{1,5} = 'solar penetration (%)';
head{1,6} = 'RES(W+S) penetration (%)';
head{1,7} = 'GHI (w/m2)';
head{1,8} = 'Wind Speed (m/s)';
head{1,9} = 'Relative Humidity (%)';
head{1,10} = 'Temperature (degree c)';
head{1,11} = 'Pressure (mbar)';
head{1,12} = 'Number of monthly abnomral date';
state_RES_weather_cell = [state_name,num2cell(state_year),num2cell(state_mon),num2cell(state_RES_weather)];
state_RES_weather_cell = [head;state_RES_weather_cell];
% save('state_RES_weather_cell','state_RES_weather_cell')

% total grid numbers under differnet RES percentage
gird_per = cell2mat(state_RES_weather_cell(2:end,6));
grid_weather = cell2mat(state_RES_weather_cell(2:end,7:12));
grid_count = [];
grid_weather_count = [];
for s=1:10
    count = 0;
    count2 = 0;
    for ss = 1:length(gird_per)
        if gird_per(ss)<s*10 && gird_per(ss)>=(s-1)*10
            count = count + 1;
            count2 = count2 + grid_weather(ss,end);
        end       
    end
    grid_count = [grid_count,count];
    grid_weather_count = [grid_weather_count,count2];
end
plot([1:10],grid_count,'r*-')
hold on
plot([1:10],grid_weather_count,'bo-')
