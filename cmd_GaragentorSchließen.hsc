! #############
! cmd_GaragentorSchließen v1.1
! #############
!
! Manuelle Auslösung
! prüft, ob Garagentor offen
! falls ja, wird Garagentor geschlossen
!
! v1.1
! 19.05.2018	1.1.0	Abfrage, ob sich CCU im Start-Modus oder im Normal-Modus befindet, hinzugefügt
! 18.05.2018	1.0.0	release

! true = Garagentor offen
! false = Garagentor zu


if (dom.GetObject("Garagentor:1").State() && !(dom.GetObject("CCU_Status").State())) {
	! Garagentor ist offen, also schließen
	! CCU_Status == true wenn die CCU im BOOT-Modus; dann soll Garagentor nicht bewegt werden!
	
	! Taster Garagentorantrieb:5
	! HM-RCV-50
	var myChannel = dom.GetObject("Taster Garagentorantrieb:5");
	var dp = myChannel.DPByHssDP("PRESS_SHORT");
	dp.State(true);
}
else {
	! Garagentor ist bereits geschlossen
	! Nichts zu tun
	
	!WriteLine("Garagentor ist bereits geschlossen. Es muss nichts gemacht werden.");
}

!WriteLine("Programm Ende");
