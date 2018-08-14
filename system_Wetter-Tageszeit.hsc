! ########
! Wetterbedingung inkl Tag/Nacht v1.0
! ########
!
! Das Script liest die Tageszeit und die aktuelle Wetterbedingung aus den entsprechenden SysVars.
! Die Kombination wird in einer weiteren SysVar gespeichert.
!
! SysVars:
! "Tag oder Nacht"
! 0 = Tag
! 1 = Nacht
!
! Wetter-Bedingungen
!
! Wetter-Bedingungen-TagNacht

var tageszeit = dom.GetObject("Tag oder Nacht");
dom.GetObject("Wetter-Bedingungen-TagNacht").State((tageszeit.ValueList().StrValueByIndex(";", tageszeit.Value())) # " - " # dom.GetObject("Wetter-Bedingungen").Value());
