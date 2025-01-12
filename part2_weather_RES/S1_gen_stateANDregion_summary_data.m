% handle wather data
% reorginize for each state
clc,clear
% In Abbre. order
State_short48={'AL','AR','AZ','CA','CO','CT','DE','FL','GA','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY'};
Elec_region13 = {'CAL','CAR','CENT','FLA','MIDA','MIDW','NE','NW','NY','SE','SW','TEN','TEX'};


storm_event = {'Severe Storm','Major Storm','Ice Storm','Thunderstorm','Tropical Storm','Winter Storm','Snow Storm','Hurricane'};
storm = {'Storm'};
wind = {'High Wind','Highwind','Wind Storm','Windstorm','Strong Wind','Heavy Wind'};
wind2 = {'Wind'};
other_weather = {'Severe Weather','Severe weather','Weather','Tropical Depression ','Heat','High Temperature','Flood','Earthquake','Fire','Natural','Nature','Ice'};
other = {'Failure','Cyber','Terrorist','Human','physical attact','Voltage Reduction','Equipment','Vandalism','Sabotage','Operat'};

% load all .mat
mat = dir('*.mat');
for q = 1:length(mat)   
    load(mat(q).name);  
end

state_weather = cell(7300,1);
state_head = cell(1,4+48*5);
state_head{1,1}='Year';
state_head{1,2}='Month';
state_head{1,3}='Day';
state_head{1,4}='Hour';
for i =1:48
    for j=1:5
        state_head{1,5*(i-1)+4+j} = State_short48{i};
    end   
end


for state_num = 1:48
    
    temp_city_GHI = [];
    temp_city_WIND = [];
    temp_city_Humidity = [];
    temp_city_Temper = [];
    temp_city_Pres = [];
    for R = 1:13
        if R == 1
            data = CAL_data;
            label = CAL_label;
        end
        if R == 2
            data = CAR_data;
            label = CAR_label;
        end
        if R == 3
            data = CENT_data;
            label = CENT_label;
        end
        if R == 4
            data = FLA_data;
            label = FLA_label;
        end
        if R == 5
            data = MIDA_data;
            label = MIDA_label;
        end
        if R == 6
            data = MIDW_data;
            label = MIDW_label;
        end
        if R == 7
            data = NE_data;
            label = NE_label;
        end
        if R == 8
            data = NW_data;
            label = NW_label;
        end
        if R == 9
            data = NY_data;
            label = NY_label;
        end
        if R == 10
            data = SE_data;
            label = SE_label;
        end
        if R == 11
            data = SW_data;
            label = SW_label;
        end
        if R == 12
            data = TEN_data;
            label = TEN_label;
        end
        if R == 13
            data = TEX_data;
            label = TEX_label;
        end
        
        idx1 = find(strcmp(label(1,:), 'GHI (w/m2)'));
        idx2 = find(strcmp(label(1,:), 'Wind Speed (m/s)'));
        city_num = idx2-idx1;%(city_num-1 = true city number)
        
        [line,column] = size(data);
        for index1 = 6:6+city_num-1
            city_name = label{2,index1};
            if strcmpi(city_name(end-1:end),State_short48{state_num}) == 1
                temp_city_GHI = [temp_city_GHI, data(:,index1-1)];% data is one line short than label!!!!!!!!!!!!!!
                temp_city_WIND = [temp_city_WIND, data(:,index1-1+city_num)];
                temp_city_Humidity = [temp_city_Humidity, data(:,index1-1+city_num*2)];
                temp_city_Temper = [temp_city_Temper, data(:,index1-1+city_num*3)];
                temp_city_Pres = [temp_city_Pres, data(:,index1-1+city_num*4)];
            end
        end
        
        
    end
    
    state_GHI = mean(temp_city_GHI,2);
    state_WIND = mean(temp_city_WIND,2);
    state_Hum = mean(temp_city_Humidity,2);
    state_Temper = mean(temp_city_Temper,2);
    state_Pres = mean(temp_city_Pres,2);
    weather = [state_GHI,state_WIND,state_Hum,state_Temper,state_Pres];
    state_weather = [state_weather,num2cell(weather)];
end
state_weather(:,1)=[];
state_weather = [num2cell(data(:,1:4)),state_weather];
state_weather = [state_head;state_weather];
save('state_weather','state_weather')


Elec_region_head = cell(1,4+13*5);
Elec_region_head{1,1}='Year';
Elec_region_head{1,2}='Month';
Elec_region_head{1,3}='Day';
Elec_region_head{1,4}='Hour';
for i =1:13
    for j=1:5
        Elec_region_head{1,5*(i-1)+4+j} = Elec_region13{i};
    end   
end
Elec_region_data = [];
for R = 1:13
    if R == 1
        data = CAL_data;
        label = CAL_label;
    end
    if R == 2
        data = CAR_data;
        label = CAR_label;
    end
    if R == 3
        data = CENT_data;
        label = CENT_label;
    end
    if R == 4
        data = FLA_data;
        label = FLA_label;
    end
    if R == 5
        data = MIDA_data;
        label = MIDA_label;
    end
    if R == 6
        data = MIDW_data;
        label = MIDW_label;
    end
    if R == 7
        data = NE_data;
        label = NE_label;
    end
    if R == 8
        data = NW_data;
        label = NW_label;
    end
    if R == 9
        data = NY_data;
        label = NY_label;
    end
    if R == 10
        data = SE_data;
        label = SE_label;
    end
    if R == 11
        data = SW_data;
        label = SW_label;
    end
    if R == 12
        data = TEN_data;
        label = TEN_label;
    end
    if R == 13
        data = TEX_data;
        label = TEX_label;
    end
    idx1 = find(strcmp(label(1,:), 'GHI (w/m2)'));
    idx2 = find(strcmp(label(1,:), 'Wind Speed (m/s)'));
    city_num = idx2-idx1;%(city_num-1 = true city number)
    
    Elec_GHI = mean(data(:,5:5+city_num-1),2);
    Elec_WIND = mean(data(:,5+city_num:5+city_num*2-1),2);
    Elec_Hum = mean(data(:,5+city_num*2:5+city_num*3-1),2);
    Elec_Temper = mean(data(:,5+city_num*3:5+city_num*4-1),2);
    Elec_Pres = mean(data(:,5+city_num*4:5+city_num*5-1),2);
    
    Elec_region_data = [Elec_region_data,Elec_GHI,Elec_WIND,Elec_Hum,Elec_Temper,Elec_Pres];     
end
Elec_region_weather = num2cell(Elec_region_data);
Elec_region_weather = [num2cell(data(:,1:4)),Elec_region_weather];
Elec_region_weather = [Elec_region_head;Elec_region_weather];
save('Elec_region_weather','Elec_region_weather')