! This rega script will be executed if hm-watchdog
! wants to notify the user. So in here you could
! either raise a alarm message or send out an email
! if the email addon is installed. On execution
! <NOTIFY_TXT> will be replaced by the real notify message.

! Comment out the following line to send out an email
dom.GetObject("CUxD.CUX2801002:1.CMD_EXEC").State("/etc/config/addons/email/email 02 '<NOTIFY_TXT>'");

! Comment out the following line if you have zPNP installed
!dom.GetObject("CCU SV Push Text").State("<NOTIFY_TXT>");
!dom.GetObject("CCU PRG Push-Nachrichten").ProgramExecute();

! Raise an alarm message in the CCU
object alarm = dom.GetObject(ID_SYSTEM_VARIABLES).Get("${sysVarAlarmZone1}");
if(alarm == null) { alarm = dom.GetObject(ID_SYSTEM_VARIABLES).Get("Alarmzone 1"); }
alarm.State(true);
alarm.DPInfo("<NOTIFY_TXT>");