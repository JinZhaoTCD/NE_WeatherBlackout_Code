clc,clear
State_short48={'AL','AR','AZ','CA','CO','CT','DE','FL','GA','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY'};
cata = {'GHI','WIND','Humudity','Temperature','Pressure','outage status','type','RES pen%','duration','demand loss','customer number'};
%%
load('database_casual_rarity');% weather condition rare level: min(low_per,high_per)
% weather condition: 0-0.1, 0.1-0.2, ..., 0.9-1.

database = database_casual_rarity;
set_weather = [0.1 0.2 0.3 0.4 0.5];

set_gap = 4;% 2000-2005;2006-2010;2011-2015;2016-2020
rarity_weather = [];
outage_status = [];
RES_pen = [];
type = [];
outage_inten = [];
for year_gap = 1:set_gap
    year_s = 365*5*(year_gap-1);
    year_e = 365*5*year_gap+2;
    year_rarity_weather = [];
    year_outage_status = [];
    year_RES_pen = [];
    year_type = [];
    year_outage_inten = [];
    for state = 1:48
        temp_weather = cell2mat(database(3+year_s:year_e,4+(state-1)*11+1:4+(state-1)*11+4));
        temp =  min(temp_weather');
        year_rarity_weather = [year_rarity_weather; temp'];
        year_outage_status = [year_outage_status; cell2mat(database(3+year_s:year_e,4+(state-1)*11+6))];
        year_type = [year_type; cell2mat(database(3+year_s:year_e,4+(state-1)*11+7))];
        year_RES_pen = [year_RES_pen; cell2mat(database(3+year_s:year_e,4+(state-1)*11+8))];
        year_outage_inten = [year_outage_inten; database(3+year_s:year_e,4+(state-1)*11+9:4+(state-1)*11+11)];
    end
    rarity_weather = [rarity_weather, year_rarity_weather];
    outage_status = [outage_status, year_outage_status];
    RES_pen = [RES_pen, year_RES_pen];
    type = [type, year_type];
    outage_inten = [outage_inten, year_outage_inten];
end

[~,count_sum] = size(set_weather);
total_num = length(rarity_weather)*set_gap;

for do_x = 1:4
    do_cal = 0;
    for year_gap = 1:set_gap
        for count = 1:count_sum
            c_z = 0;
            c_xz = 0;
            c_xyz = 0;
            for line = 1:total_num/set_gap
                if rarity_weather(line,year_gap)>=set_weather(count)-0.1 && rarity_weather(line,year_gap)<set_weather(count)
                    c_z = c_z + 1;
                    if RES_pen(line,year_gap)>=do_x*10-10 && RES_pen(line,year_gap)<=do_x*10
                        c_xz = c_xz + 1;
                        if outage_status(line,year_gap)==1 %&& type(line,year_gap)==1
                            c_xyz = c_xyz + 1;
                        end
                    end
                end
            end
            if c_xz ~= 0
                do_cal = do_cal + (c_xyz/total_num)/(c_xz/c_z);
            end
        end
    end
    do_cal
end

% customer > xxx
intensity_type = 3;%1duration,2demandMW,3customer
set_thre = 0;%24*3;
for do_x = 1:4
    do_cal = 0;
    for year_gap = 1:set_gap
        for count = 1:count_sum
            c_z = 0;
            c_xz = 0;
            c_xyz = 0;
            for line = 1:total_num/set_gap
                if rarity_weather(line,year_gap)>=set_weather(count)-0.1 && rarity_weather(line,year_gap)<set_weather(count)
                    c_z = c_z + 1;
                    if RES_pen(line,year_gap)>=do_x*10-10 && RES_pen(line,year_gap)<=do_x*10
                        c_xz = c_xz + 1;
                        if outage_status(line,year_gap)==1 %&& type(line,year_gap)==1
                            temp_check = outage_inten{line,intensity_type+3*(year_gap-1)};
                            if strcmp(class(temp_check),'double') == 1
                                if temp_check > set_thre
                                    c_xyz = c_xyz + 1;
                                end
                            end
                        end
                    end
                end
            end
            if c_xz ~= 0
                do_cal = do_cal + (c_xyz/total_num)/(c_xz/c_z);
            end
        end
    end
    do_cal
end


%----------------------- Controlled direct effect-------------------------------------------%


