$offdigit
set
     k Menge der Fahrzeuge
     i Kundenknoten
     alias(i,j)
set Kundenknoten(i) subset;


parameter
     t(i,j) Fahrzeit von Knoten i zu Knoten j
     c(i,j) Entfernung von Knoten i zu Knoten j
     d(i)   Nachfrage am Knoten i
     cap    Kapazitaet des Fahrzeugs k
     M      BigM
     Tmax   Maximale Tourdauer /10000/;

$include VRP_v1_Input_Instanz1.inc





variables Z  Zielfunktionswert;
binary variables x Transportmengen;
positive variables ld Ladungsmenge;
positive variables w Anfahrtszeitpunkte;

Equations
Zielfunktion                               Das ist die Zielfunktion
Nur_einmal_abfahren(j)                     Jeder Kundenknoten darf nur einmal angefahren werden
Nur_einmal_anfahren(j)                     Jeder Kundenknoten darf nur einmal angefahren werden
Fahrzeugkapaziteat(i,j)                    Die Kapazitaet jedes Fahrzeugs darf nicht Ueberschritten werden
Depot_einmal_pro_Fahrzeug_abfahren         Das Depot darf pro Fahrzeug nur einmal angefahren werden
Bedingung(i)                               Das ist noch eine Bedingung die noch nachzuvollziehen ist
Kapazitaet1(i)                             xxx
Kapazitaet2(i)                             dito
Kurzzyklenbedingung(i,j)                   Unterbinden von Kurzzyklen
Depot_einmal_pro_Fahrzeug_anfahren         c;

Zielfunktion..
     Z =e=   sum((i,j),c(i,j)*x(i,j));

Nur_einmal_anfahren(j)$(Kundenknoten(j))..
     sum((i)$(ord(i)<>ord(j)),x(i,j)) =e= 1;

Nur_einmal_abfahren(j)$(Kundenknoten(j))..
     sum((i)$(ord(i)<>ord(j)),x(j,i)) =e= 1;

Fahrzeugkapaziteat(i,j)$(Kundenknoten(j))..
     ld(i) =g= ld(j) + d(i) - cap*(1-x(i,j));

Depot_einmal_pro_Fahrzeug_abfahren..
     sum(i$(Kundenknoten(i)),x("dstart",i)) =l= M;

Depot_einmal_pro_Fahrzeug_anfahren..
     sum(i$(Kundenknoten(i)),x(i,"dend")) =l= M;

Bedingung(i)$(Kundenknoten(i))..
     w(i) + t(i,"dend")  =l= Tmax;

Kapazitaet1(i)..
         d(i) =l= ld(i);
Kapazitaet2(i)..
         ld(i) =l= cap;

Kurzzyklenbedingung(i,j)$(Kundenknoten(j))..
     w(j)=g=w(i)+t(i,j)-Tmax*(1-x(i,j));

model vrp /
                 Zielfunktion
                 , Nur_einmal_anfahren
                 , Nur_einmal_abfahren
                 , Fahrzeugkapaziteat
                 , Kapazitaet1
                 , Kapazitaet2
                 , Bedingung
                 , Depot_einmal_pro_Fahrzeug_abfahren
                 , Kurzzyklenbedingung
                 , Depot_einmal_pro_Fahrzeug_anfahren
                 /;




solve vrp minimizing Z using mip ;

display x.l, w.l;


file outputfile1 / 'VRP_Loesung1.txt'/;
put outputfile1;

     loop(i,
         loop(j,
            if ( x.l(i,j) = 1,
             put  i.tl:0, ' ; ' j.tl:0 /
             );
         );
     );

putclose outputfile1;

file outputfile2 / 'VRP_Loesung2.txt'/;
put outputfile2;

loop(i,
        put  i.tl:0, ' ; ',  w.l(i) /
     );

putclose outputfile2;

file outputfile3 / 'VRP_Loesung3.txt'/;
put outputfile3;

loop(i,
             put  i.tl:0, ' ; ',  ld.l(i) /
     );
putclose outputfile3;