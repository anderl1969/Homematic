! ##################
! Fenster wieder zu v1.5
! ##################
! Script zum Zurücksetzen der Alarm-Variable "Fenster Offen"
! Prüft, ob alle Fenster geschlossen sind.
! Dazu werden alle Geräte aus dem Gewerk "Verschluss" überprüft
!
! v1.5	27-07-2018
! - Ergänzung virtueller Geräte-Typ HM-CC-VG-1
! v1.4	07-04-2017
! - Ergänzung neuer Geräte-Typ: HM-Sec-TiS		
! v1.3	27-01-2016
! - Ergänzung neuer Geräte-Typ: HM-Sec-SCo
! v1.3 beta	06-01-2016
! - Testmodus: Alarm in jedem Fall ausschalten => sind weitere Fenster offen, lösen diese erneuten Alarm aus
! v1.2	29-08-2014

var meineFenster = dom.GetObject("Verschluss");
string itemId;
boolean alleFensterZu = true;
boolean fensteroffen;

foreach(itemId, meineFenster.EnumUsedIDs())
{
	var item = dom.GetObject(itemId);
	if (item.IsTypeOf(OT_CHANNEL))
	{
		var device = dom.GetObject(item.Device());

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
			! WriteLine("Name: " # device.Name());
			! WriteLine("Typ: " # device.HssType());

			var dp_state = item.DPByHssDP("STATE");
			! WriteLine("dp_state = " # dp_state.Value());
			! WriteLine("dp_state Typ = " # dp_state.Value().VarType());

            ! Unterschiedliche Rückgabewerte der einzelnen Geräte-Typen 
            ! HM-Sec-SC-2		Typ 1 = boolean		false = geschlossen, true = offen
			! HM-Sec-SCo		Typ 1 = boolean		false = geschlossen, true = offen
			! HM-Sec-RHS		Typ 2 = integer		0 = geschlossen, 1 = gekippt, 2 = offen
			! HM-Sec-TiS		Typ 1 = boolean		false = geschlossen, true = offen
			! HM-CC-VG-1		Typ 1 = boolean		false = geschlossen, true = offen

			if (dp_state.Value().VarType() == 2)
			{
				fensteroffen = !(dp_state.Value() == 0);
			}
			else
			{
				fensteroffen = dp_state.Value();
			}
			! WriteLine("Dieses Fenster offen: " # fensteroffen);
			! WriteLine("Dieses Fenster zu: " # (!fensteroffen));
			! WriteLine("Typ von fensteroffen: " # fensteroffen.VarType());

			alleFensterZu = (alleFensterZu && (!fensteroffen));
			! WriteLine("Alle Fenster zu: " # alleFensterZu);

		}
		! WriteLine("------------");
	}
}
! WriteLine("Alle Fenster zu: " # alleFensterZu);

! Zusätzliche Prüfung, ob Alarm überhaupt ausgelöst.
! Nur dann wird zurück gesetzt

! if ((alleFensterZu) && (dom.GetObject("Fenster Offen").State()))
if (dom.GetObject("Fenster Offen").State())
{
	dom.GetObject("Fenster Offen").State(false);
}
