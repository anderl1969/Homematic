! Alarm Gong OG v0.4 #
! Prüft, ob im OG ein Fenster geschlossen werden muss.
! Dazu werden alle Geräte und Kanäle aus dem Gewerk "Verschluss" überprüft
! Bei den gefundenen Kanälen wird nach bestimmten Variablen gesucht:
!
! Fenster.<Raum>.Schliessen.<Etage>.<#Sound>
!
! Es werden nur die Kanäle/Geräte berücksichtigt, die eine entsprechende
! Variable haben und zusätzlich muss die Komponente <Etage> = "OG" sein.
! Der Wert der Variable gibt an, ob das zugehörige Fenster geschlossen
! werden muss.
!
! Syntax MP3 Gong Sound-String
!
! vol, count, sec, file#1, file#2, ..., file#10 
! vol	= Lautstärke 0-100% als Dezimalzahl (z.B. 1.0 oder 0.8)
! count	= Wiederholungen (max. 255)
! sec	= Abspiellänge in Sekunden oder 108000 für Dateilänge
! file#1 = 1. von max 10 mp3 Files als Nummer
! 
! Beispiel:
! 0.8,255,108000,8, 8, 8, 8, 6, 7, 6, 7, 6, 7
! 0.4,255,108000,1,1,4,3,2
!
! 80% Lautstärke bei 255 Wiederholungen und Abspieldauer = Dateilänge
! gespielt werden 4x File #8 gefolgt von 3x File #6 und #7
!
! v0.4	27-07-2018
! - Virtuelle Heizgruppen HM-CC-VG-1 integriert
! v0.3	15-07-2018
! - ALARM "Fenster offen" wird von diesem Script gesetzt; nicht mehr von jedem einzelnen Fenster Count Script
! - ALARM "Fenster offen" wird nur ausgelöst, wenn Überwachung für das betroffene Fenster aktiviert ist
! v0.2	01-04-2017
! - Neigungssensor für Garagentor ergänzt
! v0.1	01-01-2017
! - start

var meineFenster = dom.GetObject("Verschluss");
string itemId;
string dpId;
string dpName;
string kanalAktion = "0.8,255,108000,0,";
boolean ringTheBell = false;

foreach(itemId, meineFenster.EnumUsedIDs())
{
	var item = dom.GetObject(itemId);
	if (item.IsTypeOf(OT_CHANNEL))
	{
		! item ist ein Kanal
		! device ist ein Gerät
		
		var device = dom.GetObject(item.Device());
		var channel = item;

		! Gültige Geräte
		! HM-Sec-SC-2		Tür-/Fensterkontakt
		! HM-Sec-RHS		Fenster-Drehgriffkontakt
		! HM-Sec-SCo		Tür-/Fensterkontakt optisch
		! HM-Sec-TiS		Neigungssensor
		! HM-CC-VG-1		virtuelles Gerät bei Heizgruppen
		!
		! Ungültige Geräte
		! n/a

		if ((device.HssType() == "HM-Sec-SC-2")  || (device.HssType() == "HM-Sec-RHS") || (device.HssType() == "HM-Sec-SCo") || (device.HssType() == "HM-Sec-TiS") || (device.HssType() == "HM-CC-VG-1"))
		{
			!WriteLine("Name: " # device.Name());
			!WriteLine("Typ: " # device.HssType());

			var dp_state = item.DPByHssDP("STATE");
			!WriteLine("dp_state = " # dp_state.Value());
			!WriteLine("dp_state Typ = " # dp_state.Value().VarType());
			
			foreach(dpId, channel.DPs().EnumUsedIDs())
			{
				var dp = dom.GetObject(dpId);
				if (dp.IsTypeOf(OT_VARDP))
				{
					! Variable gefunden
					! Prüfen, ob Variable den Namenskonventionen entspricht:
					! Fenster.<Raum>.Schliessen.OG.<#Sound>
					
					dpName = dp.Name();
					if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "Schliessen") && (dpName.StrValueByIndex(".", 3) == "OG"))
					{
						! Richtige Variable gefunden
						!WriteLine("Das Fenster im Raum " # dpName.StrValueByIndex(".", 1) # " muss geschlossen werden: " # dp.Value());
						if (dp.Value())
						{
							! Das Fenster muss geschlossen werden
							kanalAktion = kanalAktion # dpName.StrValueByIndex(".", 4) # ",";
							ringTheBell = true;
						}
					}
				}
			}

			!WriteLine("------------");
		}
		! WriteLine("------------");
	}
}

var kanalGongSound = dom.GetObject("Gong:Sound");
var kanalGongLED = dom.GetObject("Gong:LED");
var dp_Sound_WORKING = kanalGongSound.DPByHssDP("WORKING");
var dp_Sound_SUBMIT = kanalGongSound.DPByHssDP("SUBMIT");
var dp_LED_WORKING = kanalGongLED.DPByHssDP("WORKING");

if (ringTheBell)
{
	! Zum Abschluss das File#3 "Bitte schliessen" und #18 Stille (10sec)
	kanalAktion = kanalAktion # "3,18";
	!WriteLine ("Kanalaktion: " # kanalAktion);
	
	! Falls LED oder Sound bereits läuft, dann abschalten
	!if(dp_Sound_WORKING.Value()) {kanalGongSound.State(false);}
	!if(dp_LED_WORKING.Value()) {kanalGongLED.State(false);}
	
	! LED und Sound mit eigentlicher Aktion starten
	dp_Sound_SUBMIT.State(kanalAktion);
	kanalGongLED.State(true);

	! Alarm FENSTER OFFEN auslösen
	dom.GetObject("Fenster Offen").State(true);
}
else
{
	! Alles abschalten, was noch läuft
	
	kanalGongSound.State(false);
	kanalGongLED.State(false);
}


!WriteLine("EOF");