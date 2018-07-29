! ######################
! Fenster Count ALL v1.2
! ######################
!
! Ermittelt von welchem Fenster der Aufruf erfolgte!
! Wenn das auslösende Fenster noch offen oder gekippt ist, dann wird der Wert der Variable
! Fenster.XX.OffenSeit um 1 hochgezählt. (Die Minuten-Taktung erfolgt durch den verzögerten Script-Aufruf)
! Wenn die maximal erlaubte Öffnungszeit für das jeweilige Fenster erreicht ist, wird außerdem die
! Variable Fenster.XX.Schliessen.YY.AA auf TRUE gesetzt.
!
! $srcS = 8191		Fenster.AZ.OffenSeit
! $srcS = 10326		Fenster.Wohn.OffenSeit
! $src$ = 12671		Fenster.Garage.OffenSeit
! $src$ = 2267		Fenster.BadOG.OffenSeit
! $src$ = 15824		Fenster.Test.OffenSeit (Virtuelle Heizgruppe)
!
! v1.2	29-07-2018
! - Einführung ExtraTime für cmd_GongAlarmReset
! v1.1	22-07-2018
! - Erweiterung auf OG Fenster
! v1.0	21-07-2018
! - dynmaische Ermittlung und Berücksichtigung Sperrstunde (sofern vorhanden)
! - Unterscheidung Dreh/Kipp-Sensoreren (0, 1, 2) und Optische Sensoren sowie Neigungssensoren (true/false)
! - dynamische Ermittlung des Schwellwertes für das jeweilige Fenster
! - dynamische Ermittlung des auslösenden Kanals und der jeweiligen Variablen
! - start

var fos = dom.GetObject("$src$");									! DP : Fenster.XX.OffenSeit

if (fos) {
	var fchn = dom.GetObject(fos.Channel());                		! CHN: Fenster XX abcdefg:1
	var fsb;														! DP : Fenster.XX.Schliessen.XG.AA
	var fom;														! DP : Fenster.XX.OffenMax
	var fss;														! DP : Fenster.XX.Sperrstunde
	var fet;														! DP : Fenster.XX.ExtraTime
	integer hour = system.Date("%H").ToInteger();					! akt. Stunde für zeitbezogene Alarm-Auslösung
	integer sh;														! Sperrstunde

	! Dreh / Kipp Sensoren (Bad EG, David, Julia, AZ, Schlaf)
	! 0 = zu
	! 1 = gekippt
	! 2 = offen

	! Optische Sensoren (Wohn, ) und Neigungssensoren (Garagentor)
	! true = offen
	! false = zu

	! VarType
	! 1 = boolean => optischer Sensor
	! 2 = integer => Dreh/KippSensor
	
	if (fchn.State().VarType() == 1) {
		! VarType 1 = boolean => optischer Sensor
		if (fchn.State()) {
			fos.State(fos.Value() + 1);
		}
	}
	elseif (fchn.State().VarType() == 2) {
		! VarType 2 = integer => Dreh/Kipp Sensor
		if (fchn.State() > 0) {
			fos.State(fos.Value() + 1);
		}
	}

	! ############### DP Fenster.XX.Schliessen.XG.XX, Fenster.XX.OffenMax, Fenster.XX.Sperrstunde und Fenster.XX.ExtraTime ermitteln #############
	string dpId;
	string dpName;
	foreach(dpId, fchn.DPs().EnumUsedIDs())	{
		var dp = dom.GetObject(dpId);
		if (dp.IsTypeOf(OT_VARDP)) {
			! Variable gefunden
			! Prüfen, ob Variable den Namenskonventionen entspricht:
						
			dpName = dp.Name();

			! Fenster.<Raum>.Schliessen.OG.<#Sound>
			if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "Schliessen") && ((dpName.StrValueByIndex(".", 3) == "EG") || (dpName.StrValueByIndex(".", 3) == "OG"))) {
				! Richtige Variable gefunden
				fsb = dp;
			}

			! Fenster.<Raum>.OffenMax
			if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "OffenMax")) {
				! Richtige Variable gefunden
				fom = dp;
			}

			! Fenster.<Raum>.Sperrstunde
			if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "Sperrstunde")) {
				! Richtige Variable gefunden
				fss = dp;
			}

			! Fenster.<Raum>.ExtraTime
			if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "ExtraTime")) {
				! Richtige Variable gefunden
				fet = dp;
			}
		}
	}
	! ######################################################################

	if (fss) {
		sh = fss.Value().ToInteger();
	}
	else {
		sh = 0;
	}

	if (fos.Value() >= (fom.Value() + fet.Value())){
		if (hour >= sh) {
			fsb.State(true);
		}
	}
}

