class SessionsController < ApplicationController
  def new
    @title = "Sign in"

  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])



    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_to user
    end
  end

def build_gams_model
  if File.exists?("VRP_V3_#{current_user.id}.gms")
  else
  fil=File.new("VRP_V3_#{current_user.id}.gms", "w")

printf(fil,
"$offdigit
set
     k Menge der Fahrzeuge
     i Kundenknoten
     alias(i,j)
set Kundenknoten(i) subset;


parameter
     t(i,j) Fahrzeit von Knoten i zu Knoten j
     c(i,j) Entfernung von Knoten i zu Knoten j
     d(i)   Nachfrage am Knoten i
     cap(i) Kapazitaet des Fahrzeugs k
     BigM   BigM
     Tmax   Maximale Tourdauer
     m      Anzahl der Knoten
     tf(i)  fruehester Bedienzeitpunkt des Knoten
     ts(i)  spaetester Bedienzeitpunkt des Knoten;

$include VRP_v3_Input_Instanz1_#{current_user.id}.inc
parameter sz(i) Servicezeit;
          sz(i) = d(i)*5;
parameter BigM BigM;
         BigM = sum((i,j), t(i,j)+sz(i))+1;



variables Z  Zielfunktionswert;
binary variables x Bedienunsvariable;
binary variables y Tourvariable;
positive variables w Anfahrtszeitpunkte;
positive variable hv  Hilfsvariable;

Equations
Zielfunktion                               Das ist die Zielfunktion
Kapazitaetsrestriktion(k)                  xxx
Restriktion2(i,k)                          xxx
Restriktion3(j,k)                          xxx
Restriktion4(j)                            xxx
Restriktion5(i,j)                          xxx
Restriktion6(i,k)                          xxx
Restriktion7(i)                            xxx
Restriktion8(i)                            xxx
Restriktion9(i,j,k)                        xxx
Restriktion10(i,k)                         xxx
Restriktion11                              xxx;


Zielfunktion..
     Z =e=   sum((i,j,k),c(i,j)*x(i,j,k));

Kapazitaetsrestriktion(k)..
         sum(i, d(i)*y(i,k)) =l= cap(i);

Restriktion2(i,k)..
         sum(j, x(i,j,k)) =e= y(i,k);

Restriktion3(j,k)..
         sum(i, x(i,j,k)) =e= y(j,k);

Restriktion4(i)$(Kundenknoten(i))..
         sum(k, y(i,k)) =e= 1;

Restriktion5(i,j)$(Kundenknoten(j) and Kundenknoten(i) and ord(i)<>ord(j))..
         hv(i)-hv(j)+ m*sum(k, x(i,j,k)) =l= m-1;

Restriktion6(i,k)..
         x(i,i,k) =e= 0;

Restriktion7(i)$(Kundenknoten(i))..
         w(i) =g= tf(i);

Restriktion8(i)$(Kundenknoten(i))..
         w(i) =l= ts(i);

Restriktion9(i,j,k)$(Kundenknoten(j) and ord(i)<>ord(j))..
         w(j) =g= w(i) + sz(i) + t(i,j) - (1-x(i,j,k))*BigM;

Restriktion10(i,k)$(Kundenknoten(i))..
         w(i) + sz(i) + t(i,'depot') - (1-x(i,'depot',k))*BigM =l= Tmax;

Restriktion11..
         w('dstart')=e=0


model vrp /
                 Zielfunktion
                  ,Kapazitaetsrestriktion
                  ,Restriktion2
                  ,Restriktion3
                  ,Restriktion4
                  ,Restriktion5
                  ,Restriktion6
                  ,Restriktion7
                  ,Restriktion8
                  ,Restriktion9
                  ,Restriktion10
                  ,Restriktion11
                 /;




solve vrp minimizing Z using mip ;

display x.l, w.l;


file outputfile1 / 'VRP_Loesung1#{current_user.id}.txt'/;
put outputfile1;
   loop(k,
     loop(i,
         loop(j,
            if ( x.l(i,j,k) = 1,
             put  i.tl:0, ' ; ' j.tl:0 /
             );
         );
     );
);

putclose outputfile1;

file outputfile2 / 'VRP_Loesung2#{current_user.id}.txt'/;
put outputfile2;

loop(i,
        put  i.tl:0, ' ; ',  w.l(i) /
     );

putclose outputfile2;

file outputfile3 / 'VRP_Loesung3#{current_user.id}.txt'/;
put outputfile3;

loop(k,
loop(i,
             put  i.tl:0, ' ; ', k.tl:0, ' ;',  y.l(i,k) /
     );
);
putclose outputfile3;"

)
fil.close
end
end

def destroy




#   if File.exist?("VRP_v1_Input_Instanz1#{current_user.id}.inc")
#      File.delete("VRP_v1_Input_Instanz1#{current_user.id}.inc")
#    end
#    if File.exist?("VRP_Loesung1#{current_user.id}.txt") # datei mit der vorherigen lösung löschen
#      File.delete("VRP_Loesung1#{current_user.id}.txt")
#    end
#    if File.exist?("VRP_Loesung2#{current_user.id}.txt") # datei mit der vorherigen lösung löschen
#      File.delete("VRP_Loesung2#{current_user.id}.txt")
#    end
#    if File.exist?("VRP_Loesung3#{current_user.id}.txt") # datei mit der vorherigen lösung löschen
#      File.delete("VRP_Loesung3#{current_user.id}.txt")
#    end
#   if File.exist?("VRP_V3_#{current_user.id}.gms") # datei mit der vorherigen lösung löschen
#      File.delete("VRP_V3_#{current_user.id}.gms")
#      end
      redirect_to root_path
     sign_out
end




end