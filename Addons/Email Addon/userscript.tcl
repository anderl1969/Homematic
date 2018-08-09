set Datum [clock format [clock seconds] -format "%d.%m.%Y  %H:%M"]
set mapping [list \
	+	" "		%3A	":"		%E4	"ä"		%F6	"ö"		%FC	"ü"		%C4	"Ä" \
	%D6	"Ö"		%DC	"Ü"		%DF	"ß"		%2C	","		%3B	";"		%21	"!" \
	%3F	"?"		%2B	"+"		%2A	"*"		%2F	"/"		%3D	"="		%3C	"<" \
	%3E	">"		%A7	"§"		%24	"$"		%25	"%"		%26	"&"		%28	"(" \
	%29	")"		%23	"#"		%80	"€"		%27	"'" \
]

load tclrega.so

array set values [rega_script {
   ! ab hier HM-Script => Kommentare beginnen mit !
   ! var v1 = dom.GetObject("EmailEmpfaenger").Value();
   ! var v2 = dom.GetObject("EmailBetreff").Value();
   ! var v3 = dom.GetObject("EmailText").Value();

   dom.GetObject("CUxD.CUX2801002:1.CMD_SETS").State("cat /boot/VERSION");
   dom.GetObject("CUxD.CUX2801002:1.CMD_QUERY_RET").State(1);

   var version = dom.GetObject("CUxD.CUX2801002:1.CMD_RETS").State();

} ]

# ab hier wieder TCL => Kommentare beginnen mit #
# set v1 $values(v1)
# set v2 $values(v2)
# set v3 $values(v3)
set version $values(version)

# Übergebene Parameter (nach der ID für die Vorlage) werden in $text abgelegt
set text [lindex $argv 1]
set textutf8 [encoding convertfrom utf-8 [lindex $argv 1]]

set textall $argv
set text1 [string map $mapping [string range [lindex $argv 2] 3 end]]
set text2 [string map $mapping [string range [lindex $argv 3] 3 end]]
set text3 [string map $mapping [string range [lindex $argv 4] 3 end]]
set text4 [string map $mapping [string range [lindex $argv 5] 3 end]]
set text5 [string map $mapping [string range [lindex $argv 6] 3 end]]
