class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml

  def index
    @projects = current_user.projects

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @links =Link.find(:all)
    @project = Project.find(params[:id])
 #   @nodes = Node.where(:project_id => @project)
    @nodes = Node.find(:all)
    @json = @nodes.to_gmaps4rails
#    @json = Link.find(:all).to_gmaps4rails
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new(:user_id => current_user[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @title = "Edit project"
  end
  def show_solution
    #if Link.where(:user_id => current_user[:id]).nil?
    #  respond_to do |format|

    #    format.html { redirect_to(user_path, :notice => 'Project was successfully created.') }
     #end# redirect_to(user_path, :notice => "Bitte ermitteln Sie zunächst eine zulässige Lösung")
    #else

    #Link.where(:user_id => current_user[:id])
    @links =Link.where(:user_id => current_user[:id])
    #@project = Project.find(params[:id])
    @json = Node.where(:user_id => current_user[:id]).to_gmaps4rails

    render :template => "projects/solution"
    #end
    end


  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user[:id]
    respond_to do |format|
      if @project.save
        format.html { redirect_to(projects_path, :notice => 'Project was successfully created.') }
        format.xml { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml { head :ok }
    end
  end

  def optimize
    @project = Project.where(:user_id => current_user[:id])
    @nodes = Node.where(:user_id => current_user[:id])
    @vehicles = Vehicle.where(:user_id => current_user[:id])
    @user = User.where(:id => current_user[:id])

#    if File.exists?("VRP_V3.gms")
#    File.open("VRP_V3.gms", "r+") do |line|
#    while (at_line-=20) >0
#       line.readline
#    end
#    position = line.position
#    rest = line.read
#    line.seek position
#    line.write ["$include VRP_v3_Input_Instanz1#{current_user.id}.inc", rest]





    current_user[:optimized] = true

    if File.exist?("VRP_v1_Input_Instanz1.inc")
      File.delete("VRP_v1_Input_Instanz1.inc")
    end
    if File.exist?("VRP_Loesung1.txt") # datei mit der vorherigen lösung löschen
      File.delete("VRP_Loesung1.txt")
    end
    if File.exist?("VRP_Loesung2.txt") # datei mit der vorherigen lösung löschen
      File.delete("VRP_Loesung2.txt")
    end
    if File.exist?("VRP_Loesung3.txt") # datei mit der vorherigen lösung löschen
      File.delete("VRP_Loesung3.txt")
    end

######print set#####
    fil=File.new("VRP_v1_Input_Instanz1.inc", "w") # w für write
    printf(fil, "set i / \n")

    @nodes.each { |so|
      if so.depot?
        printf(fil, "depot" + "\n")
      else
        printf(fil, "i" + so.id.to_s + "\n")
      end } #schreibe sie in die include datei
    printf(fil, "/" + "\n\n")

    printf(fil, "set k / \n")
    @vehicles.each { |so|
        printf(fil, "v" + so.id.to_s + "\n")
      }
    printf(fil, "/;" + "\n\n")

#####Knotenanzahl definieren#####
    printf(fil, "Scalar m / \n")
    printf(fil, @nodes.count.to_s + "\n")
    printf(fil, "/;" + "\n\n")

#####maximale Tourdauer definieren#####
    printf(fil, "Scalar Tmax / \n")
    printf(fil, current_user[:tourduration] + "\n")
    printf(fil, "/;" + "\n\n")


#####print distance matrix#####

    @nodes.each do |i|
      @nodes.each do |j|
        if i!=j
         if current_user.distance_accuracy?
          x=Gmaps4rails.destination(
              {"from" => "#{i.street}+#{i.city}", "to" => "#{j.street}+#{j.city}"})
          distance = x.first["distance"]["value"]
         else
          distance2=Geocoder::Calculations.distance_between([i.latitude, i.longitude], [j.latitude, j.longitude])
          distance=distance2*Geocoder::Calculations.mi_in_km
         end
          if i.depot?
            printf(fil, "c('depot','i#{j.id.to_s}')= #{distance};" + "\n")


          else
            if j.depot?
              printf(fil, "c('i#{i.id.to_s}','depot')= #{distance};" + "\n")


            else
              printf(fil, "c('i#{i.id.to_s}','i#{j.id.to_s}')= #{distance};" + "\n")
            end
          end

        else
          if i.depot?
            printf(fil, "c('depot','depot')= 0;" + "\n")


          else
            printf(fil, "c('i#{i.id.to_s}','i#{j.id.to_s}')= 0;" + "\n")
          end
        end

      end
    end

    printf(fil, "\n\n")
#
####print duration matrix#####


    @nodes.each do |i|
      @nodes.each do |j|
        if i!=j
          if current_user.duration_accuracy?
         x=Gmaps4rails.destination(
         {"from" => "#{i.street}+#{i.city}", "to" => "#{j.street}+#{j.city}"})
         duration = x.first["duration"]["value"]
         else
          duration2=Geocoder::Calculations.distance_between([i.latitude, i.longitude], [j.latitude, j.longitude])
          duration=duration2*Geocoder::Calculations.mi_in_km
         end
          if i.depot?
            printf(fil, "t('depot','i#{j.id.to_s}')= #{duration};" + "\n")

          else
            if j.depot?
              printf(fil, "t('i#{i.id.to_s}','depot')= #{duration};" + "\n")

            else
              printf(fil, "t('i#{i.id.to_s}','i#{j.id.to_s}')= #{duration};" + "\n")
            end
          end

        else
          if i.depot?
            printf(fil, "t('depot','depot')= 0;" + "\n")
          else
            printf(fil, "t('i#{i.id.to_s}','i#{j.id.to_s}')= 0;" + "\n")
          end
        end


      end
    end

    printf(fil, "\n\n")

#####Depot Knoten definieren#####
    printf(fil, "Kundenknoten(i) = yes;\n")

    @nodes.each do |li|
      if li.depot?
        printf(fil, "Kundenknoten('depot') = no;"+"\n")

      end
    end
    printf(fil, "\n\n")

#####Fahrzeugkapazitäten definieren#####
    printf(fil, "parameter cap(k) /"+"\n")
    @vehicles.each do |v|
    printf(fil, "v" +v.id.to_s + " " + v.Capacity.to_s)
    printf(fil, "\n")
    end
    printf(fil, "/;" + "\n\n")

#####Früheste Bedienzeitpunkte definieren#####
    printf(fil, "parameter tf(i) /"+"\n")
    @nodes.each do |node|
    if node.depot?
    printf(fil, "depot ")
    printf(fil, node.earliest)
    printf(fil, "\n")
    else
    printf(fil, "i" +node.id.to_s + " " + node.earliest)
    printf(fil, "\n")
    end
    end
    printf(fil, "/;" + "\n\n")

#####Späteste Bedienzeitpunkte definieren#####
    printf(fil, "parameter ts(i) /"+"\n")
    @nodes.each do |node|
    if node.depot?
    printf(fil, "depot ")
    printf(fil, node.latest)
    printf(fil, "\n")
    else
    printf(fil, "i" +node.id.to_s + " " + node.latest)
    printf(fil, "\n")
    end
    end
    printf(fil, "/;" + "\n\n")

#####Nachfrage definieren#####
    printf(fil, "parameter d(i) /"+"\n")

    @nodes.each do |k|
      if k.depot?
        printf(fil, "depot ")
        printf(fil, "0")
        printf(fil, "\n")
      else
        printf(fil, "i" +k.id.to_s)
        demand=k.demand
        printf(fil, " " + demand.to_s)
        printf(fil, "\n")
      end
    end
    printf(fil, "/;" + "\n\n")
    fil.close

    system "gams VRP_V3"



    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml { render :xml => @project }
    end
  end


  def read_vrp_solution
    @projects = Project.find(:all)
    @links = Link.find(:all)
    if File.exist?("VRP_Loesung1.txt")
      fi=File.open("VRP_Loesung1.txt", "r")
      fi.each { |line|
        sa=line.split(" ; ")
        link = Link.new do |link|
          if (sa[0] != "dstart" && sa[0] != "dend")
            sa1=sa[0].delete "i"
            link.fromnode = sa1.to_i
          else
            fromn= Node.where(:depot => true).first
            link.fromnode = fromn[:id]
          end
          if (sa[1] != "dstart\n" && sa[1] != "dend\n")
            sa1=sa[1].delete "i"
            link.tonode = sa1.to_i
          else
            ton = Node.where(:depot => true).first
            link.tonode = ton[:id]
          end
          link.save
        end
      }

    end
    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml { render :xml => @project }
    end
    end

    def read_polyline


   @links = Link.find(:all)
   @nodes = Node.find(:all)
   @links.each do |link|


      nodefr = Node.where(:id => link.fromnode).first
      nodet = Node.where(:id => link.tonode).first
   #   @nodefrom.each do |nodefr|
   #   @nodeto.each do |nodet|


      x=Gmaps4rails.destination(
              #  {"from" => "#{Node.where(:id => "#{link.fromnode}").street}+#{Node.where(:id => "#{link.fromnode}").city}", "to" => "#{Node.where(:id => "#{link.tonode}").street}+#{Node.where(:id => "#{link.tonode}").city}"})
          {"from" => "#{nodefr[:street]}+#{nodefr[:city]}", "to" => "#{nodet[:street]}+#{nodet[:city]}"})
          #{"from" => "#{Node.find_by_id(link.fromnode).street}+#{Node.find_by_id(link.fromnode).city}", "to" => "#{Node.find_by_id(link.tonode).street}+#{Node.find_by_id(link.tonode).city}"})
           polyline = x.last["polylines"]
        link.polyline = polyline
        link.fromlatitude = nodefr[:latitude]
        link.fromlongitude = nodefr[:longitude]
        link.tolatitude = nodet[:latitude]
        link.tolongitude = nodet[:longitude]
        link.gmaps = true

      link.save


      end
    #  end

    #end


    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml { render :xml => @project }
    end

#  def read_and_show_ofv
#    if File.exists?("Zielfunktionswert_v2.txt")
#    fi=File.open("Zielfunktionswert_v2.txt", "r")
#    line=fi.readline
#    sa=line.split(" ")
#   @objective_function_value=sa[1]
#    else
#    @objective_function_value=nil
#    end
#    @transport_links = TransportLink.find(:all)
#    render :template => "transport_links/index"
#  end

  end
end
