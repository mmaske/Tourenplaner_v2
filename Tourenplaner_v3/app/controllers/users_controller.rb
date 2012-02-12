class UsersController < ApplicationController
  include SessionsHelper
  def new
    @user = User.new
    @title = "Sign up"


  end

   def show
    @user = User.find(params[:id])
    @title = @user.name
   end

  def create
    @user = User.new(params[:user])
    @user.optimized=false

    if @user.save

      sign_in @user
      flash[:success] = "Ihr Account wurde erfolgreich angelegt"
      @project = Project.new(:user_id => current_user[:id])
      @project.save
      redirect_to root_path
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    current_user[:optimized] = false

    respond_to do |format|
      if @user.update_attributes(params[:user])
       # current_user[:optimized] = false
        format.html { redirect_to(@user, :notice => 'Maximale Tourdauer wurde gesetzt') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

    def edit
    @user = User.find(params[:id])
    current_user[:optimized] = false
    end

end
