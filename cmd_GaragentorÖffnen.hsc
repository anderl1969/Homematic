! ##############
! cmd_GaragentorÖffnen v1.1
! ##############
!
! Manuelle Auslösung
! prüft, ob Garagentor zu
! falls ja, wird Garagentor geöffnet
!
! v1.1
! 19.05.2018	1.1.0	Abfrage, ob sich CCU im Start-Modus oder im Normal-Modus befindet, hinzugefügt
! 18.05.2018	1.0.0	release

! true = Garagentor offen
! false = Garagentor zu

!WriteLine(dom.GetObject("Garagentor:1").State());
if (!dom.GetObject("Garagentor:1").State() && !(dom.GetObject("CCU_Status").State())) {
	! Garagentor ist zu, also öffnen
	! CCU_Status == true wenn die CCU im BOOT-Modus; dann soll Garagentor nicht bewegt werden!
	
	! Taster Garagentorantrieb:5
	! HM-RCV-50
	var myChannel = dom.GetObject("Taster Garagentorantrieb:5");
	var dp = myChannel.DPByHssDP("PRESS_SHORT");
	dp.State(true);
}
else {
	! Garagentor ist bereits offen
	! Nichts zu tun
	
	!WriteLine("Garagentor ist bereits offen. Es muss nichts gemacht werden.");
}

!WriteLine("Programm Ende");