class NodesController < ApplicationController


  # GET /nodes
  # GET /nodes.xml
  def index
    @nodes = Node.where(:user_id => current_user[:id])
    @json = Node.where(:user_id => current_user[:id]).to_gmaps4rails

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nodes }
    end
  end

  # GET /nodes/1
  # GET /nodes/1.xml
  def show
    @node = Node.find(params[:id])
    @json = Node.find(params[:id]).to_gmaps4rails
   # @json = Node.where(:user_id => current_user[:id]).to_gmaps4rails
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @node }
    end
  end

  # GET /nodes/new
  # GET /nodes/new.xml
  def new
    @node = Node.new(:user_id => current_user[:id])


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @node }
    end
  end

  # GET /nodes/1/edit
  def edit
    @node = Node.find(params[:id])
    @json = Node.find(params[:id]).to_gmaps4rails
    current_user[:optimized] = false
  end

  # POST /nodes
  # POST /nodes.xml
  def create


    @node = Node.new(params[:node])
    @node.user_id = current_user[:id]
    @json = Node.where(:user_id => current_user[:id]).to_gmaps4rails
    current_user[:optimized] = false




    respond_to do |format|
      if @node.save
        format.html { redirect_to(nodes_path, :notice => 'Node was successfully created.') }
        format.xml  { render :xml => @node, :status => :created, :location => @node }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nodes/1
  # PUT /nodes/1.xml
  def update
    @node = Node.find(params[:id])
    @json = Node.all.to_gmaps4rails

    respond_to do |format|
      if @node.update_attributes(params[:node])
        current_user[:optimized] = false
        format.html { redirect_to(nodes_path, :notice => 'Node was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.xml
  def destroy
    @node = Node.find(params[:id])
    @node.destroy
    current_user[:optimized] = false

    respond_to do |format|
      format.html { redirect_to(nodes_url) }
      format.xml  { head :ok }
    end
  end
end
