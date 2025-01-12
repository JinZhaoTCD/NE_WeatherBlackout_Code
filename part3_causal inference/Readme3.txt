1. S1_generate_casual_table generates the 'database_causal_rarity.m' which records the time, weather outage status (1 yes 0 no), type(1 weather-induced, 0 non-weather induced), and all the outage information of 48 states.


2. Run S2_cal_casual_effect.m to get the do calculus.

type(line,year_gap)==1:weather induced events
type(line,year_gap)==0:non-weather induced events