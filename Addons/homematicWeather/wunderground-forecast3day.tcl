#!/bin/tclsh

# load libaries
load tclrega.so

# include config
source conf/config.tcl

# config
set sysvar1 Wetter-MaxTemp-Heute
set sysvar2 Wetter-MinTemp-Heute
set sysvar3 Wetter-Regen-Heute
set sysvar4 Wetter-MaxTemp-Morgen
set sysvar5 Wetter-MinTemp-Morgen
set sysvar6 Wetter-Regen-Morgen
set sysvar7 Wetter-MaxTemp-Uebermorgen
set sysvar8 Wetter-MinTemp-Uebermorgen
set sysvar9 Wetter-Regen-Uebermorgen

set url http://api.wunderground.com/api/$key/forecast10day/lang:DL/q/Germany/$ort.xml
if { [catch {exec /usr/bin/wget -q -O /usr/local/addons/homematicWeather/wunderground-forecast3day.xml $url} error] } {
    puts stderr "Could not reach $url \n$error"
    exit 1
}

set f [open "/usr/local/addons/homematicWeather/wunderground-forecast3day.xml"]
set input [read $f]
close $f


# Simpleforecast
# period 1
regexp "</date>\n\t\t\t\t\t<period>1(.*?)</forecastday>" $input dummy period1 ;
#max temp
regexp "<high>(.*?)</high>" $period1 dummy high ;
regexp "<celsius>(.*?)</celsius>" $high dummy maxtemp1 ;
#low temp
regexp "<low>(.*?)</low>" $period1 dummy low ;
regexp "<celsius>(.*?)</celsius>" $low dummy lowtemp1 ;
#rain %
regexp "<pop>(.*?)</pop>" $period1 dummy pop1 ;

# period 2
regexp "</date>\n\t\t\t\t\t<period>2(.*?)</forecastday>" $input dummy period2 ;
#max temp
regexp "<high>(.*?)</high>" $period2 dummy high ;
regexp "<celsius>(.*?)</celsius>" $high dummy maxtemp2 ;
#low temp
regexp "<low>(.*?)</low>" $period2 dummy low ;
regexp "<celsius>(.*?)</celsius>" $low dummy lowtemp2 ;
#rain %
regexp "<pop>(.*?)</pop>" $period2 dummy pop2 ;

# period 3
regexp "</date>\n\t\t\t\t\t<period>3(.*?)</forecastday>" $input dummy period3 ;
#max temp
regexp "<high>(.*?)</high>" $period3 dummy high ;
regexp "<celsius>(.*?)</celsius>" $high dummy maxtemp3 ;
#low temp
regexp "<low>(.*?)</low>" $period3 dummy low;
regexp "<celsius>(.*?)</celsius>" $low dummy lowtemp3 ;
#rain %
regexp "<pop>(.*?)</pop>" $period3 dummy pop3;

set rega_cmd ""
append rega_cmd "dom.GetObject('$sysvar1').State('$maxtemp1');"
append rega_cmd "dom.GetObject('$sysvar2').State('$lowtemp1');"
append rega_cmd "dom.GetObject('$sysvar3').State('$pop1');"
append rega_cmd "dom.GetObject('$sysvar4').State('$maxtemp2');"
append rega_cmd "dom.GetObject('$sysvar5').State('$lowtemp2');"
append rega_cmd "dom.GetObject('$sysvar6').State('$pop2');"
append rega_cmd "dom.GetObject('$sysvar7').State('$maxtemp3');"
append rega_cmd "dom.GetObject('$sysvar8').State('$lowtemp3');"
append rega_cmd "dom.GetObject('$sysvar9').State('$pop3');"
rega_script $rega_cmd
exit 0;
