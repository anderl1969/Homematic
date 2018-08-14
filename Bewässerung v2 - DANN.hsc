! Bewässerung v2 - DANN
! 
! Wird ausgelöst, wenn Bewässerungszeitraum beginnt
! Überprüft, ob Bedingungen für Bewässerung erfüllt sind
!
! v1.2
! 18.07.2015	1.2.0	Erweiterung um Force-Modus
! 16.07.2015	1.1.0	Umstellung Pumpen-Logik	
! 27.04.2015	1.0.1 	email-Adresse aktualisiert
! 16.09.2014	1.0.0 	release

boolean pump;
boolean watering;
integer days;
boolean go;
boolean force;

string MailEmpfaenger = "a.haberl@outlook.com";
string MailBetreff = "Info HomeMatic - Brunnen";
string MailText;
string ActionText;
string ReasonText;

!Wir befinden uns in einem möglichen Bewässerungszeitraum
dom.GetObject("Bewässerungszeitraum aktiv").State(true);

pump = dom.GetObject("Hauswasserwerk Aktiv").State();
watering = dom.GetObject("Bewässerung Aktiv").State();
days = dom.GetObject("Regenlose Tage").Variable().ToInteger();
force = dom.GetObject("Bewässerung erzwingen").State();

! Ob die Pumpe vorher an oder aus ist, wird nicht mehr beachtet!
! Am Ende der Bewässerung wird die Pumpe wieder in den ursprünglichen Zustand versetzt
!if (pump) {
	if (force) {
		! Bewässerung erzwingen = aktiv
		! keine weitere Prüfung
		go = true;
		ReasonText = "Ursache: Bewässerung erzwingen\r\n";
	}
	else {
		if (watering) {
			if (days > 2) {
				! Seit mehr als 2 Tagen kein Regen
				! Bewässern
				go = true;
				ReasonText = "Ursache: Trockenheit seit mehr als 2 Tagen\r\n";
			}
			else {
				! kürzlich geregnet
				go = false;
				ReasonText = "Ursache: kürzlich geregnet\r\n";
			}
		}
		else {
			! Bewässerungsmodus AUS
			go = false;
			ReasonText = "Ursache: Bewässerungsmodus AUS\r\n";
		}
	}
!}
!else {
	! Hauswasserwerk-Modus AUS
!	go = false;
!	ReasonText = "Ursache: Hauswasserwerk-Modus AUS (innerhalb Zeitraum)\r\n";
!}


dom.GetObject("Hauswasserwerk:1").State(go);

! Hier den Inhalt der Mail angeben
MailText = "####################################\r\n";
MailText = MailText # "#                               Info                                            #\r\n";
MailText = MailText # "####################################\r\n";
MailText = MailText # "\r\n";
if (go) {
	ActionText = "Brunnen wurde angeschaltet / angelassen\r\n";
}
else {
	ActionText = "Brunnen wurde ABGESCHALLTET\r\n";
}

MailText = MailText # ActionText;
MailText = MailText # ReasonText;

string stdout;
string stderr;
string teilstr;
string sendmail = "";
string sendbetreff = "";
string mailto = "";

foreach(teilstr, MailBetreff.Split(" ")){
   sendbetreff = sendbetreff # "+" # teilstr;
}

foreach(teilstr, MailText.Split(" ")){
   sendmail = sendmail # "+" # teilstr;
}

foreach(teilstr, MailEmpfaenger.Split(" ")){
   mailto = mailto # "+" # teilstr;
}

!Winter: wenn keine tägl. Emails erwünscht, folgende Zeile auskommentieren
!system.Exec ("/bin/sh /etc/config/addons/mh/email.sh "# sendbetreff # " " # sendmail # " " # mailto, &stdout, &stderr);

