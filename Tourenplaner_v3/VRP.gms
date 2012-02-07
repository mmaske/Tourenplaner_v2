$offdigit
set
     k Menge der Fahrzeuge
     i Kundenknoten
     Kundenknoten(i)
     alias(h,i,j);

parameter
     t(i,j) Fahrzeit von Knoten i zu Knoten j
     c(i,j) Entfernung von Knoten i zu Knoten j
     d(i)   Nachfrage am Knoten i
     cap(k) Kapazität des Fahrzeugs k
     M      BigM;
scalar M BigM /100000000000/;
$include VRP_v1_Input_Instanz1.inc



variables Z  Zielfunktionswert;
binary variables x Transportmengen;
positive variable w Anfahrtszeitpunkt;


Equations
Zielfunktion                               Das ist die Zielfunktion
Nur_einmal_anfahren(i)                     Jeder Kundenknoten darf nur einmal angefahren werden
Fahrzeugkapaziteat(k)                      Die Kapazitaet jedes Fahrzeugs darf nicht überschritten werden
Depot_einmal_pro_Fahrzeug_anfahren(k)      Das Depot darf pro Fahrzeug nur einmal angefahren werden
Depot_einmal_pro_Fahrzeug_abfahren(k)      Das Depot darf pro Fahrzeug nur einmal angefahren werden
Bedingung_noch_nachzuvollziehen(h,k)       Das ist noch eine Bedingung die noch nachzuvollziehen ist
Und_noch_so_eine(k)                        dito
Kurzzyklenbedingung(i,j,k)                 Unterbinden von Kurzzyklen;

Zielfunktion..
     Z =e=   sum((i,j,k),c(i,j)*x(i,j,k));

Nur_einmal_anfahren(i)$(Kundenknoten(i))..
     sum((k,j),x(i,j,k)) =e= 1;

Fahrzeugkapaziteat(k)..
     sum(i$(Kundenknoten(i)),d(i)* sum(j,x(i,j,k))) =l= cap(k);

Depot_einmal_pro_Fahrzeug_abfahren(k)..
     sum(j,x("d",j,k)) =e= 1;

Bedingung_noch_nachzuvollziehen(h,k)$(Kundenknoten(h))..
     sum(i,x(i,h,k))-sum(j,x(h,j,k)) =e= 0;

Depot_einmal_pro_Fahrzeug_anfahren(k)..
     sum(i,x(i,"d",k)) =e= 1;

Kurzzyklenbedingung(i,j,k)..
     w(i,k)+t(i,j)-M*(1-x(i,j,k)) =l= w(j,k);

model vrp /
                 Zielfunktion
                 , Nur_einmal_anfahren
                 , Fahrzeugkapaziteat
                 , Depot_einmal_pro_Fahrzeug_abfahren
                 , Bedingung_noch_nachzuvollziehen
                 , Depot_einmal_pro_Fahrzeug_anfahren
                 , Kurzzyklenbedingung
                 /;




solve vrp minimizing Z using mip;

display x.l, w.l;