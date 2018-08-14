! ########
! Tage ohne Regen v1,1
! ########
!
! v1.1
! 04.06.2015	1.1.0	Einführung Toleranz für regenlosen Tag
! 15.09.2014	1.0.0	release

integer days;
integer prox;

days = dom.GetObject("Regenlose Tage").Variable().ToInteger();
prox = dom.GetObject("Wetter-Regen-Heute").Variable().ToInteger();

if (prox <= 20) {
	! Ein weiterer Tag ohne Regen
	! Bei einer Wahrscheinlichkeit <= 20% wird von regenlosem Tag ausgegangen
	days = days + 1;
}
else {
	! Heute soll es regnen
	days = 0;
}

dom.GetObject("Regenlose Tage").Variable(days);

!WriteLine(days);
!WriteLine(dom.GetObject("Regenlose Tage").Variable());
