! Bewässerung v2 - SONST
! 
! Wird ausgelöst, wenn Bewässerungszeitraum endet
! Überprüft, was mit Pumpe geschehen soll
!
! v1.2
! 18.07.2015	1.2.0	Erweiterung um Force-Modus
! 27.04.2015	1.0.1 	email-Adresse aktualisiert
! 16.09.2014	1.0.0 	release


boolean pump;
boolean watering;
integer days;
boolean go;

string MailEmpfaenger = "a.haberl@outlook.com";
string MailBetreff = "Info HomeMatic - Brunnen";
string MailText;
string ActionText;
string ReasonText;

!Wir befinden uns AUßERHALB eines möglichen Bewässerungszeitraum
dom.GetObject("Bewässerungszeitraum aktiv").State(false);

! Abhänging von "Hauswasserwerk Aktiv" wird Pumpe wieder aktiviert
pump = dom.GetObject("Hauswasserwerk Aktiv").State();
go = pump;
dom.GetObject("Hauswasserwerk:1").State(go);

! Bewässerung erzwingen nur 1x ausführen, deshalb zurücksetzen
dom.GetObject("Bewässerung erzwingen").State(false);


! Hier den Inhalt der Mail angeben
MailText = "####################################\r\n";
MailText = MailText # "#                               Info                                            #\r\n";
MailText = MailText # "####################################\r\n";
MailText = MailText # "\r\n";
if (go) {
	ActionText = "Brunnen wurde angeschaltet / angelassen\r\n";
	ReasonText = "Ursache: Hauswasserwerkmodus AN (außerhalb Zeitraum)\r\n";
}
else {
	ActionText = "Brunnen wurde ABGESCHALTET\r\n";
	ReasonText = "Ursache: Hauswasserwerkmodus AUS (außerhalb Zeitraum)\r\n";
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

!system.Exec ("/bin/sh /etc/config/addons/mh/email.sh "# sendbetreff # " " # sendmail # " " # mailto, &stdout, &stderr);

