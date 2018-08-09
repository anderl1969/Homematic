! Dieses Script wird nach x Minuten ausgelöst
! CCU_Status sollte FALSE = NORMAL sein

var status_named = dom.GetObject("CCU_Status").ValueName();
var prog = dom.GetObject($this$);

dom.GetObject ("CUxD.CUX9100001:1.TEMPLATEID").State(03);
dom.GetObject ("CUxD.CUX9100001:1.OPTION_1").State("Der CCU-Status ist: " # status_named);
dom.GetObject ("CUxD.CUX9100001:1.OPTION_2").State ("Das Script '" # prog # "' wurde getriggert.");
dom.GetObject ("CUxD.CUX9100001:1.OPTION_3").State ("Vermutlich wurde die CCU neu gestartet!");
dom.GetObject ("CUxD.CUX9100001:1.OPTION_4").State (" ");
dom.GetObject ("CUxD.CUX9100001:1.OPTION_5").State ("");

!Email versenden
dom.GetObject ("CUxD.CUX9100001:1.SEND").State (1);

! Die Option-Felder wieder löschen
dom.GetObject ("CUxD.CUX9100001:1.OPTION_1").State ("");
dom.GetObject ("CUxD.CUX9100001:1.OPTION_2").State ("");
dom.GetObject ("CUxD.CUX9100001:1.OPTION_3").State ("");
dom.GetObject ("CUxD.CUX9100001:1.OPTION_4").State ("");
dom.GetObject ("CUxD.CUX9100001:1.OPTION_5").State ("");