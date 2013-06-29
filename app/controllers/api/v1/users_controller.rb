class Api::V1::UsersController < ApplicationController
  before_filter :login_required
  
  # GET /users.xml
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.json { render :action => "index" }
      format.xml  { render :action => "index" }
    end
  end
    
  # GET /users/1.xml
  # GET /users/1.json
  def show
    @user = User.find_by_id(params[:id])
    respond_to do |format|
      if params[:id].blank?
        format.json { render :json => { :error => "No ID provided" }, :status => 400 }
        format.xml { render :xml => "<error>No ID provided</error>", :status => 400 }
      elsif @user.blank?
        format.json { render :json => { :error => "User with ID #{params[:id]} Not Found" }, :status => 404 }
        format.xml { render :xml => "<error>User with ID #{params[:id]} Not Found</error>", :status => 404 }
      else
        format.json { render :action => "show" }
        format.xml  { render :action => "show" }
      end
    end
  end
  
  # POST /users.xml
  # POST /users.json
  def create
    @user = User.new_from_api(params[:user])
    @user.roles.add!(Role.cp)
    respond_to do |format|
      if @user.save
        format.json { render :action => 'show' }
        format.xml  { render :action => 'show' }
      else
        format.json { render :json => @user.errors, :status => 400 }
        format.xml  { render :xml => @user.errors, :status => 400 }
      end
    end
  end
end
