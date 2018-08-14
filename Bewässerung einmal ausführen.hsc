! #######
! Bewässerung einmal ausführen v1.1
! #######
! 
! Wird manuell ausgeführt
! Schaltet die Systemvariable "Bewässerung" erzwingen um
!
! v1.1
! 19.05.2018	1.1.0	Abfrage, ob sich CCU im Start-Modus oder im Normal-Modus befindet, hinzugefügt
! 18.07.2015	1.0.0 	release

boolean force;

if !(dom.GetObject("CCU_Status").State()) {
	! Code wird nur ausgeführt, wenn CCU_Status = false (normal)
	force = dom.GetObject("Bewässerung erzwingen").State();
	force = !force;
	dom.GetObject("Bewässerung erzwingen").State(force);
}
