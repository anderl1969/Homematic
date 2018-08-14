! Part of "Schaltet Hauswasserwerkmodus"
! DANN-Zweig
!
! Wird ausgelöst, wenn HAUSWASSERWERKMODUS aktiviert wird
! Überprüft, ob Hauswasserwerk tatsächlich eingeschaltet werden darf
!
! v1.0
! 16.09.2014

if (dom.GetObject("Bewässerungszeitraum aktiv").State()) {
	! Nur anmachen, wenn Bewässerungskriterien erfüllt, ansonsten warten auf Ende Bewässerungszeitraum
	! Pumpe wird am Ende des Bewässerungszeitraum vom entsprechenden Skript aktiviert

	boolean watering;
	integer days;

	watering = dom.GetObject("Bewässerung Aktiv").State();
	days = dom.GetObject("Regenlose Tage").Variable().ToInteger();

	if (watering && (days > 2)) {
		dom.GetObject("Hauswasserwerk:1").State(true);
	}
}
else {
	!Pumpe kann problemlos angemacht werden
	dom.GetObject("Hauswasserwerk:1").State(true);
}