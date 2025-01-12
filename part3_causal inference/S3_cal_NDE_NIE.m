clc,clear
State_short48={'AL','AR','AZ','CA','CO','CT','DE','FL','GA','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY'};
cata = {'GHI','WIND','Humudity','Temperature','Pressure','outage status','type','RES pen%','duration','demand loss','customer number'};
%%
load('database_casual_rarity');% weather condition rare level: min(low_per,high_per)
% weather condition: 0-0.1, 0.1-0.2, ..., 0.9-1.

database = database_casual_rarity;
set_weather = [0.1 0.2 0.3 0.4 0.5];

rarity_weather = [];
outage_status = [];
RES_pen = [];
type = [];
outage_inten = [];

year_s = 0;
year_e = 365*20+2;
for state = 1:48
    temp_weather = cell2mat(database(3+year_s:year_e,4+(state-1)*11+1:4+(state-1)*11+4));
    temp =  min(temp_weather');
    rarity_weather = [rarity_weather; temp'];
    outage_status = [outage_status; cell2mat(database(3+year_s:year_e,4+(state-1)*11+6))];
    type = [type; cell2mat(database(3+year_s:year_e,4+(state-1)*11+7))];
    RES_pen = [RES_pen; cell2mat(database(3+year_s:year_e,4+(state-1)*11+8))];
    outage_inten = [outage_inten; database(3+year_s:year_e,4+(state-1)*11+9:4+(state-1)*11+11)];
end


[~,count_sum] = size(set_weather);
total_num = length(rarity_weather);


%----------------------- consider time-------------------------------------------%

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



set_x1 = 1;
set_x2 = 5;
%-------------------------calculate TE----------------------------------%
c_x1 = 0;
c_x1y = 0;
c_x2 = 0;
c_x2y = 0;
for year_gap = 1:set_gap
    for line = 1:total_num/set_gap
        if rarity_weather(line,year_gap)>=set_weather(set_x1)-0.1 && rarity_weather(line,year_gap)<set_weather(set_x1)
            c_x1 = c_x1 + 1;
            if outage_status(line,year_gap)==1 %&& type(line,year_gap)==1
                c_x1y = c_x1y + 1;
            end
        end
        if rarity_weather(line,year_gap)>=set_weather(set_x2)-0.1 && rarity_weather(line,year_gap)<set_weather(set_x2)
            c_x2 = c_x2 + 1;
            if outage_status(line,year_gap)==1 %&& type(line,year_gap)==1
                c_x2y = c_x2y + 1;
            end
        end
    end
end
TE_cal =  c_x1y/c_x1 - c_x2y/c_x2


%-------------------------calculate NDE_cal----------------------------------%
NDE_cal = 0;
pre_cal_x2t = zeros(1,set_gap);
for year_gap = 1:set_gap
    c_tem = 0;
    for line = 1:total_num/set_gap
        if rarity_weather(line,year_gap)>=set_weather(set_x2)-0.1 && rarity_weather(line,year_gap)<set_weather(set_x2)
            c_tem = c_tem + 1;
        end
    end
    pre_cal_x2t(year_gap) = c_tem;
end

for year_gap = 1:4
    length(find(type(:,year_gap)==1))
    %length(find(outage_status(:,year_gap)==1))
end

for Z_RES = 1:4
    for year_gap = 1:set_gap
        c_x1zt = 0;
        c_x1zty = 0;
        c_x2zt = 0;
        c_x2zty = 0;
        c_x2t = pre_cal_x2t(year_gap);
        for line = 1:total_num/set_gap
            if RES_pen(line,year_gap)>=Z_RES*10-10 && RES_pen(line,year_gap)<=Z_RES*10 %RES_pen(line,year_gap)>=Z_RES*10-10 && RES_pen(line,year_gap)<=Z_RES*10+10
                if rarity_weather(line,year_gap)>=set_weather(set_x1)-0.1 && rarity_weather(line,year_gap)<set_weather(set_x1)
                    c_x1zt = c_x1zt + 1;
                    if outage_status(line,year_gap)==1 %&& type(line,year_gap)==1
                        c_x1zty = c_x1zty + 1;
                    end
                end
                if rarity_weather(line,year_gap)>=set_weather(set_x2)-0.1 && rarity_weather(line,year_gap)<set_weather(set_x2)
                    c_x2zt = c_x2zt + 1;

                    if outage_status(line,year_gap)==1 %&& type(line,year_gap)==1
                        c_x2zty = c_x2zty + 1;
                    end
                end
            end
        end
       if c_x1zt ~= 0 && c_x2zt ~= 0
            E_x1zt = c_x1zty/c_x1zt;
            E_x2zt = c_x2zty/c_x2zt;
            P_Z_x2t = c_x2zt/c_x2t;
            NDE_cal = NDE_cal + (E_x1zt-E_x2zt)*P_Z_x2t*(1/set_gap);
       end
    end
end


%-------------------------calculate NIE_cal----------------------------------%
% Reverse x1 and x2. NIE(x1->x2) = NDE(x2->x1) - TE(x2->x1) 
NIE_cal = NDE_cal - TE_cal
NIE_cal/TE_cal

fprintf('TE is %8.6f\n', TE_cal);


fprintf('NDE is %8.6f\n', NDE_cal)
fprintf('NDE_cal/TE_cal is %8.6f\n', NDE_cal/TE_cal)
fprintf('1-NDE_cal/TE_cal is %8.6f\n', 1-NDE_cal/TE_cal)

fprintf('NIE is %8.6f\n', NIE_cal)
%reversed_NIE/original_TE  fprintf('NIE_cal/TE_cal is %8.6f\n', NIE_cal/TE_cal)


% % customer > xxx
% intensity_type = 1;%1duration,2demandMW,3customer
% set_thre = 24*3;
% for Z_RES = 1:4
%     do_cal = 0;
%     for year_gap = 1:set_gap
% 
%         c_z = 0;
%         c_x1zt = 0;
%         c_xyzt = 0;
%         for line = 1:total_num/set_gap
%             if rarity_weather(line,year_gap)>=set_weather(count)-0.1 && rarity_weather(line,year_gap)<set_weather(count)
%                 c_z = c_z + 1;
%                 if RES_pen(line,year_gap)>=Z_RES*10-10 && RES_pen(line,year_gap)<=Z_RES*10
%                     c_x1zt = c_x1zt + 1;
%                     if outage_status(line,year_gap)==1 %&& type(line,year_gap)==1
%                         temp_check = outage_inten{line,intensity_type+3*(year_gap-1)};
%                         if strcmp(class(temp_check),'double') == 1
%                             if temp_check > set_thre
%                                 c_xyzt = c_xyzt + 1;
%                             end
%                         end
%                     end
%                 end
%             end
%         end
%         if c_x1zt ~= 0
%             do_cal = do_cal + (c_xyzt/total_num)/(c_x1zt/c_z);
%         end
% 
%     end
% end


%----------------------- Controlled direct effect-------------------------------------------%


