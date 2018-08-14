#!/bin/tclsh

# load libaries
load tclrega.so

# include config
source conf/config.tcl

#
# Read weather data <Ort>
# Update der Daten auf wunderground erfolgt immer zur vollen Stunde
#
# Variablen:
#
set sysvar0 Wetter-Aktualisierung
set sysvar1 Wetter-Bedingungen
set sysvar2 Wetter-Temperatur
set sysvar3 Wetter-Windgeschwindigkeit
set sysvar4 Wetter-Windboeen
set sysvar5 Wetter-Windrichtung
# set sysvar6 Wetter-Windbedingungen
set sysvar7 Wetter-Luftdruck
set sysvar8 Wetter-Luftdrucktrend
set sysvar9 Wetter-Luftfeuchte

set url http://api.wunderground.com/api/$key/conditions/lang:DL/q/Germany/$ort.xml
if { [catch {exec /usr/bin/wget -q -O /usr/local/addons/homematicWeather/wunderground-simple.xml $url} error] } {
    puts stderr "Could not reach $url \n$error"
    exit 1
}

set f [open "/usr/local/addons/homematicWeather/wunderground-simple.xml"]
set input [read $f]
close $f

#
# goto section with current observation
#
regexp "<current_observation>(.*?)</current_observation>" $input dummy current  ; #get current observation
#
regexp "<observation_time>Last Updated on (.*?)</observation_time>" $current dummy observation_time  ; # letzter update
regexp "<weather>(.*?)</weather>" $current dummy weather  ; # wetterbedingungen
regexp "<temp_c>(.*?)</temp_c>" $current dummy temp_c  ; # temperatur # ZAHL
regexp "<wind_kph>(.*?)</wind_kph>" $current dummy wind_kph  ; # Windgeschwindigkeit # ZAHL
regexp "<wind_gust_kph>(.*?)</wind_gust_kph>" $current dummy wind_gust_kph  ; # Windboeengeschwindigkeit # ZAHL
regexp "<wind_dir>(.*?)</wind_dir>" $current dummy wind_dir  ; # windrichtung
# regexp "<wind_string>(.*?)</wind_string>" $current dummy wind_string  ; # windbedingungen
regexp "<pressure_mb>(.*?)</pressure_mb>" $current dummy pressure_mb  ; # Luftdruck #ZAHL
regexp "<pressure_trend>(.*?)</pressure_trend>" $current dummy pressure_trend  ; # Luftdrucktrend
regexp "<relative_humidity>(.*?)</relative_humidity>" $current dummy relative_humidity  ; # Luftfeuchte

# Umlaute korrigieren

switch $wind_dir {
        "Südwest"          {set wind_dir "S▒dwest"}
        "Südost"           {set wind_dir "S▒dost"}
        "West-Südwest"     {set wind_dir "West-S▒dwest"}
        "Süd-Südwest"     {set wind_dir "S▒d-S▒dwest"}
        "Ost-Südost"       {set wind_dir "Ost-S▒dost"}
        "Süd-Südost"      {set wind_dir "S▒d-S▒dost"}
}

#
# set ReGaHss variables
#
set rega_cmd ""
append rega_cmd "dom.GetObject('$sysvar0').State('$observation_time');"
append rega_cmd "dom.GetObject('$sysvar1').State('$weather');"
append rega_cmd "dom.GetObject('$sysvar2').State('$temp_c');"
append rega_cmd "dom.GetObject('$sysvar3').State('$wind_kph');"
append rega_cmd "dom.GetObject('$sysvar4').State('$wind_gust_kph');"
append rega_cmd "dom.GetObject('$sysvar5').State('$wind_dir');"
# append rega_cmd "dom.GetObject('$sysvar6').State('$wind_string');"
append rega_cmd "dom.GetObject('$sysvar7').State('$pressure_mb');"
append rega_cmd "dom.GetObject('$sysvar8').State('$pressure_trend');"
append rega_cmd "dom.GetObject('$sysvar9').State('$relative_humidity');"
rega_script $rega_cmd
exit 0;
