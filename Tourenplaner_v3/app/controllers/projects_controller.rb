class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml

  def index
    @projects = Projects.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    # @nodes = Node.where(:project_id => @project)
    @nodes = Node.find(:all)
    @json = @nodes.to_gmaps4rails
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

    @vehicles = Vehicle.where(:user_id => current_user[:id])
    @nodes =Node.where(:user_id => current_user[:id]).order(:servicetime)
    @json = Node.where(:user_id => current_user[:id]).to_gmaps4rails



    render :template => "projects/solution"
  end


  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user[:id]
    respond_to do |format|
      if @project.save
    project = Project.where(:user_id => current_user[:id]).first
    project.loading = false
    project.optimized = false
    project.save

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
    project = Project.where(:user_id => current_user[:id]).first
    project.loading = false
    project.optimized = false
    project.save
    @nodes = Node.where(:user_id => current_user[:id])
    if @nodes != nil
    @nodes.each do |node|
      node.jobnumber = nil
      node.vehicle_id = nil
      node.servicetime = nil
      node.tour_id = nil
      node.save
    end
    end
        format.html { redirect_to(root_path, :notice => 'Ihre Eingaben wurden erfolgreich gespeichert') }
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



    if File.exist?("VRP_v1_Input_Instanz1.inc")
      File.delete("VRP_v1_Input_Instanz1.inc")
    end
    if File.exist?("VRP_Loesung1.txt")
      File.delete("VRP_Loesung1.txt")
    end
    if File.exist?("VRP_Loesung2.txt")
      File.delete("VRP_Loesung2.txt")
    end
    if File.exist?("VRP_Loesung3.txt")
      File.delete("VRP_Loesung3.txt")
    end

######print set#####
    fil=File.new("VRP_v1_Input_Instanz1.inc", "w")
    printf(fil, "set i / \n")

    @nodes.each { |so|
      if so.depot?
        printf(fil, "depot" + "\n")
      else
        printf(fil, "i" + so.id.to_s + "\n")
      end }
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
    printf(fil, Project.where(:user_id => current_user[:id]).first.tourduration.to_s + "\n")
    printf(fil, "/;" + "\n\n")


#####print distance matrix#####

    @nodes.each do |i|
      @nodes.each do |j|
        if i!=j
          if Project.where(:user_id => current_user[:id]).first.distance_accuracy?
            x=Gmaps4rails.destination(
                {"from" => "#{i.street}+#{i.city}", "to" => "#{j.street}+#{j.city}"})
              #  {"from" => "(#{i.longitude}),(#{i.latitude})", "to" => "(#{j.longitude}),(#{j.latitude})"})
            distance = x.first["distance"]["value"]
            sleep 2
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

####print duration matrix#####


    @nodes.each do |i|
      @nodes.each do |j|
        if i!=j
          if Project.where(:user_id => current_user[:id]).first.duration_accuracy?
            x=Gmaps4rails.destination(
                {"from" => "#{i.street}+#{i.city}", "to" => "#{j.street}+#{j.city}"})
               # {"from" => "(#{i.longitude}),(#{i.latitude})", "to" => "(#{j.longitude}),(#{j.latitude})"})
            duration = x.first["duration"]["value"]
            sleep 2
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
        printf(fil, node.earliest.to_s)
        printf(fil, "\n")
      else
        printf(fil, "i" +node.id.to_s + " " + node.earliest.to_s)
        printf(fil, "\n")
      end
    end
    printf(fil, "/;" + "\n\n")

#####Späteste Bedienzeitpunkte definieren#####
    printf(fil, "parameter ts(i) /"+"\n")
    @nodes.each do |node|
      if node.depot?
        printf(fil, "depot ")
        printf(fil, node.latest.to_s)
        printf(fil, "\n")
      else
        printf(fil, "i" +node.id.to_s + " " + node.latest.to_s)
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

    project = Project.where(:user_id => current_user[:id]).first
    project.loading = false
    project.optimized = true
    project.save

   redirect_to(root_path)
  end


  def read_vrp_solution

    project = Project.where(:user_id => current_user[:id]).first
    project.loading = true
    project.save

    @nodes = Node.where(:user_id => current_user[:id])
    @nodes.each do |node|
      node.jobnumber = nil
      node.vehicle_id = nil
      node.servicetime = nil
      node.tour_id = nil
      node.save
    end


    if File.exist?("VRP_Loesung1.txt")
      fi=File.open("VRP_Loesung1.txt", "r")
      fi.each { |line|
        k = line.strip.squeeze(" ")
        sa=k.split(" ; ")
        sa3 = sa[3].delete "v"
        sa0 = sa[0].delete "i"
        sa1 = sa[1].delete "i"
        vehic_id = sa3.to_i
        if sa0 != "depot"
          node1 = Node.where(:id => sa0.to_i, :user_id => current_user[:id]).first
           if node1 != nil
            node1.vehicle_id = vehic_id
            node1.save
         end
        end
        if sa1 != "depot"
          node2 = Node.where(:id => sa1.to_i, :user_id => current_user[:id]).first
          if node2 != nil
            node2.vehicle_id = vehic_id
            node2.save
           end
        end
      }
      fi.close
    end

    if File.exist?("VRP_Loesung2.txt")
      fi=File.open("VRP_Loesung2.txt", "r")
      fi.each { |line|
        k = line.strip.squeeze(" ")
        sa=k.split(" ; ")
        if sa[0] != "depot"
          sa1=sa[0].delete "i"
          sa2=sa1.to_i
          node = Node.where(:id => sa2, :user_id => current_user[:id]).first
          if node != nil
            node.servicetime = sa[1].to_f
            node.save
          end
        else
          sa1=sa[0]
          sa2=sa1.to_i
          @nodes = Node.where( :user_id => current_user[:id], :depot => true).all
          @nodes.each do |node|
            if node != nil
              node.servicetime = 0
              node.save
            end
          end
        end
      }
      fi.close
    end

    depot = Node.where(:user_id => current_user[:id], :depot => true).first
    depot.jobnumber = 1
    depot.save

    @vehicles = Vehicle.where(:user_id => current_user[:id]).order(:id).all

    zaehlertour = 1
    @vehicles.each do |vehicle|
    @nodes = Node.where(:user_id => current_user[:id], :vehicle_id => vehicle.id).order(:servicetime).all

    zaehlerjob = 2
    if @nodes != nil
      @nodes = Node.where(:user_id => current_user[:id], :vehicle_id => vehicle.id).order(:servicetime).each do |node|
     # @nodes.each do |node|
        if node.depot?
          node.jobnumber=1
          node.save
        else

            node.jobnumber = zaehlerjob
            node.tour_id = zaehlertour
            node.save
            zaehlerjob = zaehlerjob + 1

        end
      end
    end
      zaehlertour = zaehlertour + 1
    end
   project = Project.where(:user_id => current_user[:id]).first
   project.loading = true
   project.save

   redirect_to(solution_path(current_user))

  end

end
