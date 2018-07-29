
if (!(dom.GetObject("CCU_Status").State())) {
	! Ausführung nur, wenn CCU_Status = false (Normal-Modus)

	var meineFenster = dom.GetObject("Verschluss");
	string itemId;
	string dpId;
	string dpName;

	var fal;														! DP : Fenster.XX.Alarm
	var fsb;														! DP : Fenster.XX.Schliessen.XG.AA
	var fom;														! DP : Fenster.XX.OffenMax
	var fss;														! DP : Fenster.XX.Sperrstunde
	var fet;														! DP : Fenster.XX.ExtraTime

	foreach(itemId, meineFenster.EnumUsedIDs())
	{
		fal = null;
		fsb = null;
		fom = null;
		fss = null;
		fet = null;

		var item = dom.GetObject(itemId);
		if (item.IsTypeOf(OT_CHANNEL))
		{
			! item ist ein Kanal
			! device ist ein Gerät
			
			var device = dom.GetObject(item.Device());
			var channel = item;

			foreach(dpId, channel.DPs().EnumUsedIDs())
			{
				var dp = dom.GetObject(dpId);
				if (dp.IsTypeOf(OT_VARDP))
				{
					! Variable gefunden
					! Prüfen, ob Variable den Namenskonventionen entspricht:
						
					dpName = dp.Name();

					! Fenster.<Raum>.Alarm
					if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "Alarm"))	{
						fal = dp;
					}

					! Fenster.<Raum>.Schliessen.OG.<#Sound>
					if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "Schliessen") && ((dpName.StrValueByIndex(".", 3) == "EG") || (dpName.StrValueByIndex(".", 3) == "OG")))	{
						fsb = dp;
					}

					! Fenster.<Raum>.OffenMax
					if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "OffenMax"))	{
						fom = dp;
					}

					! Fenster.<Raum>.Sperrstunde
					if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "Sperrstunde"))	{
						fss = dp;
					}

					! Fenster.<Raum>.ExtraTime
					if((dpName.StrValueByIndex(".", 0) == "Fenster") && (dpName.StrValueByIndex(".", 2) == "ExtraTime"))	{
						fet = dp;
					}

				}
			}
			WriteLine("Fenster\t: " # device);

			Write("fal\t: " # fal # "\t\t");
			if (fal) {
				Write(fal.Value());
			}
			WriteLine("");

			Write("fsb\t: " # fsb # "\t");
			if (fsb) {
				Write(fsb.Value());
			}
			WriteLine("");

			Write("fom\t: " # fom # "\t\t");
			if (fom) {
				Write(fom.Value());
			}
			WriteLine("");

			Write("fss\t: " # fss # "\t\t");
			if (fss) {
				Write(fss.Value());
			}
			WriteLine("");

			Write("fet\t: " # fet # "\t\t");
			if (fet) {
				Write(fet.Value());
			}
			WriteLine("");

			WriteLine("------------");
		}
	}	
}