1. S1-S3 are used to prepare the event-weather rarity dataset.

2. Directly Run S4_draw_rare_figure to get weather rarity figures

3. Use 'select weather = x' to select the weather type.

%13-17 are respectively {'GHI (w/m2)'} {'Wind Speed (m/s)'} {'Relative Humidity (%)'} {'Temperature (degree c)'} {'Pressure (mbar)'}

If you use select weather =  [13 14 15 16], it will find the minimum of all the weather types.

4. Use "intensity_type" and "thresh_hold" to select events beyond a level of intensity

E.g. intensity_type= 7, thresh_hold = 1000
Means only events have more than 1000 affected customers will be counted  

intensity_type= 3/6/7 %3duration,6demandMW,7 affected customer number

5. Run .m file in the cluster folder to get weather cluster figure