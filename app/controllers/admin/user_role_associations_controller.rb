class Admin::UserRoleAssociationsController < AdminController
  before_filter :find_role
  def index
    @user_role_associations = @role.user_role_associations
    @user_role_associations_paginated = @role.user_role_associations.paginate :page => params[:page]

    @create_link_text = "(+) Grant User CP Status" if @role.andand.name == "cp"
    @create_link_text = "(+) Grant User Admin Status" if @role.andand.name =="citizen_effect_admin"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
      format.xls { send_as_xls("#{@role.andand.name}_list") }
    end
  end

  def destroy
    @user_role_association = @role.user_role_associations.find(params[:id])
    @user_role_association.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, @role, :user_role_associations]) }
      format.xml  { head :ok }
    end
  end

  def new
    @user_role_association = @role.user_role_associations.build
    @users = User.find_all_without_role_id(@role.id) || []
  end

  def create
    @user_role_association = @role.user_role_associations.build(params[:user_role_association])
    respond_to do |format|
      if @user_role_association.save
        flash[:notice] = 'User and Role Association was successfully created.'
        format.html { redirect_to(admin_role_user_role_associations_path(@role.id)) }
        format.xml  { render :xml => @user_role_association, :status => :created, :location => @user_role_association }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_role_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def find_role
    @role = Role.find(params[:role_id])
  end
end

