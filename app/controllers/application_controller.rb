# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include SslRequirement
  
  helper :all # include all helpers, all the time
  
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
  protect_from_forgery unless Rails.env.development?
  
  
  #set our custom error form fields
  before_filter :set_field_error_proc
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  # always store current request if it is a get (except for login/signup)
  after_filter :store_get_request_location
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  helper_method :recently_viewed_projects, :current_user_can_edit_project?, :current_user_can_edit_public_project?

  def render_404(page_wanted = nil)
    logger.info "Could not find `#{page_wanted}'" if page_wanted
    request.format = :html
    render :template => "shared/404", :layout => 'application', :status => 404 
  end

protected
  def require_citizen_effect_admin
    if !logged_in? || !current_user.is_a_citizen_effect_admin?
      redirect_to :back rescue redirect_to home_index_path
      flash[:error] = "You do not have sufficient privileges for that action."
      logger.error "citizen_effect_admin required"
      false
    end
  end
  
  def require_citizen_effect_admin_or_partner_admin
    if !logged_in? || !current_user.is_a_citizen_effect_admin_or_partner_admin?
      redirect_to :back rescue redirect_to home_index_path
      flash[:error] = "You do not have sufficient privileges for that action."
      logger.error "citizen_effect_admin or partner_admin required"
      false
    end
  end
    
  def require_admin_or_match_given_user(u = @user)
    if u != current_user && (!logged_in? || !current_user.is_a_citizen_effect_admin?)
      redirect_to :back rescue redirect_to home_index_path
      flash[:error] = "You do not have sufficient privileges for that action."
      logger.error "citizen_effect_admin or match given user required"
      false
    end
  end
  
  def set_field_error_proc
    ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| html_tag }
  end
  
  def require_cp_for_project #depends on @project being available
    if !current_user_can_edit_public_project?(@project)
      redirect_to :back rescue redirect_to home_index_path
      flash[:error] = "You must be a cp for this project for that action."
      logger.error "cp or admin required"
      false
    else
      true
    end
  end
  
  def current_user_can_edit_project?(p = @project)
    logged_in? && current_user.editable_projects.include?(p)
  end
  
  # Partner admins cannot edit the public project page, only the project page in the admin side
  def current_user_can_edit_public_project?(p = @project)
    logged_in? && current_user.projects_editable_on_public_site.include?(p)
  end
  
  def update_recently_viewed_projects(project)
    projects_to_keep = 15
    session[:recently_viewed_project_ids] ||= []
    session[:recently_viewed_project_ids].delete(project.id)
    session[:recently_viewed_project_ids].unshift(project.id)
    session[:recently_viewed_project_ids].slice!(projects_to_keep, projects_to_keep)
    @recently_viewed_projects = nil
  end
  
  def recently_viewed_projects
    @recently_viewed_projects ||= begin
                                    session[:recently_viewed_project_ids] ||= []
                                    Project.user_visible_projects.find_all_by_id(
                                                         session[:recently_viewed_project_ids])
                                  end
#     @recently_viewed_projects[0, 3] # STUB until we can handle more with carousels
  end
  
  def render_optional_error_file(status_code)
    if status_code == :not_found
      render_404
    else
      super
    end
  end
  
  alias :ar_ssl_required? :ssl_required? 
  def ssl_required?
    REQUIRE_SSL && ar_ssl_required?
  end

  
end
