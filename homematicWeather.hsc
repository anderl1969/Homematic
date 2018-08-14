! Wunderground Wetter-Daten holen

! Var: Wetterprognose-Mond 			<Zeichenkette>
! dom.GetObject("CUxD.CUX2801001:1.CMD_EXEC").State("cd /usr/local/addons/homematicWeather && tclsh wunderground-astronomy.tcl");

! Var: Wetterprognose-Aktuell			<Zeichenkette>
! dom.GetObject("CUxD.CUX2801001:1.CMD_EXEC").State("cd /usr/local/addons/homematicWeather && tclsh wunderground-conditions.tcl");

! Var: Wetterprognose 				<Zeichenkette>
! dom.GetObject("CUxD.CUX2801001:1.CMD_EXEC").State("cd /usr/local/addons/homematicWeather && tclsh wunderground-forecast.tcl");

! Var: Wetter-MaxTemp-Heute 		Zahl 		°C
! Var: Wetter-MaxTemp-Morgen 		Zahl 		°C
! Var: Wetter-MaxTemp-Uebermorgen 	Zahl 		°C
! Var: Wetter-MinTemp-Heute 		Zahl 		°C
! Var: Wetter-MinTemp-Morgen 		Zahl 		°C
! Var: Wetter-MinTemp-Uebermorgen 	Zahl 		°C
! Var: Wetter-Regen-Heute 			Zahl 		%
! Var: Wetter-Regen-Morgen 			Zahl 		%
! Var: Wetter-Regen-Uebermorgen 	Zahl 		%
! dom.GetObject("CUxD.CUX2801001:1.CMD_EXEC").State("cd /usr/local/addons/homematicWeather && tclsh wunderground-forecast10day.tcl");
dom.GetObject("CUxD.CUX2801002:1.CMD_EXEC").State("cd /usr/local/addons/homematicWeather && tclsh wunderground-forecast3day.tcl");

! Var: Wetter-Aktualisierung
! Var: Wetter-Bedingungen
! Var: Wetter-Temperatur
! Var: Wetter-Windgeschwindigkeit
! Var: Wetter-Windboeen
! Var: Wetter-Windrichtung
! Var: Wetter-Luftdruck
! Var: Wetter-Luftdrucktrend
! Var: Wetter-Luftfeuchte
dom.GetObject("CUxD.CUX2801002:1.CMD_EXEC").State("cd /usr/local/addons/homematicWeather && tclsh wunderground-simple.tcl");
