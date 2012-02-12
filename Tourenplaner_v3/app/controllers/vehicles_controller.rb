class VehiclesController < ApplicationController
  # GET /vehicles
  # GET /vehicles.xml
  def index
    @vehicles = Vehicle.where(:user_id => current_user[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @vehicles }
    end
  end

  # GET /vehicles/1
  # GET /vehicles/1.xml
  def show
    @vehicle = Vehicle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @vehicle }
    end
  end

  # GET /vehicles/new
  # GET /vehicles/new.xml
  def new
    @vehicle = Vehicle.new
    @vehicle = Vehicle.new(:user_id => current_user[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @vehicle }
    end
  end

  # GET /vehicles/1/edit
  def edit
    @vehicle = Vehicle.find(params[:id])
  end

  # POST /vehicles
  # POST /vehicles.xml
  def create
    @vehicle = Vehicle.new(params[:vehicle])
    @vehicle.user_id = current_user[:id]

    respond_to do |format|
      if @vehicle.save
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
        format.html { redirect_to(@vehicle, :notice => 'Vehicle was successfully created.') }
        format.xml { render :xml => @vehicle, :status => :created, :location => @vehicle }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @vehicle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vehicles/1
  # PUT /vehicles/1.xml
  def update
    @vehicle = Vehicle.find(params[:id])

    respond_to do |format|
      if @vehicle.update_attributes(params[:vehicle])
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
        format.html { redirect_to(@vehicle, :notice => 'Vehicle was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @vehicle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.xml
  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy
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
    respond_to do |format|
      format.html { redirect_to(vehicles_url) }
      format.xml { head :ok }
    end
  end
end
