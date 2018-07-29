! cmd_FensterGongReset v1.2
!
! Manuelle Auslösung
! setzt den Alarmgeber für den Fenster-Gong zurück
! es wird so getan, also würde das alarmauslösende Fenster kurz geschlossen
! und erneut geöffnet
!
! v1.2	29-07-2018
! Umstellung auf ExtraTime - die bisherige Manipulation der Variablen "OffenSeit" führte zu einem zusätzl.
! Antriggern von Fenster Count ALL und damit zu einer falschen Zeitzählung
! v1.1	27-07-2018
! virtuelles Gerät HM-CC-VG-1 erlaubt
! v1.0
! 31.05.2018	1.0.0	release


! Test Konfiguration
!var temp = dom.GetObject("Fenster.AZ.Schliessen.EG.16");
!temp.State(true);
!var temp = dom.GetObject("Fenster.AZ.OffenSeit");
!temp.State(20);

if (!(dom.GetObject("CCU_Status").State())) {
	! Ausführung nur, wenn CCU_Status = false (Normal-Modus)

	!Welches Fenster löst den Alarm aus?

	var meineFenster = dom.GetObject("Verschluss");
	string itemId;
	string dpId;
	string dpName;

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
						if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "Schliessen") && ((dpName.StrValueByIndex(".", 3) == "EG") || (dpName.StrValueByIndex(".", 3) == "OG")))
						{
							! Richtige Variable gefunden
							!WriteLine("Das Fenster im Raum " # dpName.StrValueByIndex(".", 1) # " muss geschlossen werden: " # dp.Value());
							!WriteLine(dpName);
							if (dp.Value())
							{
								! Das Fenster muss geschlossen werden
								! kanalAktion = kanalAktion # dpName.StrValueByIndex(".", 4) # ",";
								! ringTheBell = true;
								!WriteLine("zurücksetzen");
								dp.State(false);
								!OffenSeit Variable ermitteln
								!var dpOffenSeit = dom.GetObject("Fenster." # dpName.StrValueByIndex(".", 1) # ".OffenSeit");
								var dpExtraTime = dom.GetObject("Fenster." # dpName.StrValueByIndex(".", 1) # ".ExtraTime");
								var dpOffenMax = dom.GetObject("Fenster." # dpName.StrValueByIndex(".", 1) # ".OffenMax");
								!dpOffenSeit.State(0);
								dpExtraTime.State(dpExtraTime.Value() + dpOffenMax.Value());
								!WriteLine(dp.Value() # " / " # dpOffenSeit.Value());
								
							}
						}
					}
				}

				!WriteLine("------------");
			}
			!WriteLine("------------");
		}
	}	
}