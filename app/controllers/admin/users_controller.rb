class Admin::UsersController < AdminController
  before_filter :find_user

  def new
    @user = User.new
  end
  
  def edit
  end
 
  def create
    @user = User.new(params[:user])
    @user.do_not_send_emails = true
    @user.state = "active"
    @user.activated_at = Time.now.utc
    @user.activation_code = nil
    
    @user.roles << Role.citizen_effect_admin if params[:is_ce_admin] == "1"
    @user.roles << Role.cp if params[:is_cp] == "1"
      
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to [:edit, :admin, @user]
    else
      render :action => "new"
    end
  end
  
  def update
    if params[:is_ce_admin] == "1"
      @user.roles << Role.citizen_effect_admin unless @user.roles.include?(Role.citizen_effect_admin)
    else
      @user.roles.delete(Role.citizen_effect_admin)
    end
    
    if params[:is_cp] == "1"
      @user.roles << Role.cp unless @user.roles.include?(Role.cp)
    else
      @user.roles.delete(Role.cp)
    end
      
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to [:edit, :admin, @user]
    else
      render :action => "new"
    end
    
  end
  
  def change_password
    if request.put?
      if @user.update_attributes(:password => params[:user].andand[:password], :password_confirmation => params[:user].andand[:password_confirmation])
        flash[:notice] = "Password updated!"
        redirect_to admin_all_users_path
      end
    end
  end
  
  def activate
    @user.activate!
    flash[:notice] = "User activated!"
    redirect_to admin_all_users_path
  end

protected
  def find_user
    @user = User.find(params[:id]) if params[:id]
  end
end
