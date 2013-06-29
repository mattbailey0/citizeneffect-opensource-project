# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  ssl_required :new, :create  
  skip_after_filter :store_get_request_location
  
  # render new.rhtml
  def new
    if current_user
      flash[:notice] = "You are already logged in."
      redirect_back_or_default
    end
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_based_on_role
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    token = session[:_csrf_token]
    logout_killing_session!
    session[:_csrf_token] = token
    
    flash[:notice] = "You have been logged out."
    
    redirect_back_or_default(home_index_path)
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
  
  def redirect_back_or_based_on_role
    path = if current_user.is_a_partner_admin? || current_user.is_a_citizen_effect_admin?
             session[:return_to] = nil
             admin_root_path
           else
             home_index_path
           end
    redirect_back_or_default(path)
  end
end
