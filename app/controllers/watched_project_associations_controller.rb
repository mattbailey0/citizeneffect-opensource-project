class WatchedProjectAssociationsController < ApplicationController
  
  before_filter :find_user
  before_filter :require_admin_or_match_given_user
  
  layout proc{ |c| c.request.xhr? ? false : "application" }
  
  def index
    @watched_project_associations = @user.watched_project_associations # STUB should be most recently added first, and limited to 6
    @news_items = @user.watch_list_news_feed[0, 9] # STUB should be most recently added first, and limited to 9
    @project = Project.first # @watched_projects.first # for similar projects # STUB, what shoes up when you haven't wated anything?
  end

  def create
    return unless request.xhr? && request.post?

    @association = WatchedProjectAssociation.new(params[:watched_project_association])
    if @association.save
      render :partial => "projects/added_to_watchlist", :layout => false, :locals => { :project => @association.project, :association => @association }
    else
      render :partial => "projects/failed_at_add_to_watchlist", :layout => false
    end
  end
  
  def destroy
    @watched_project_entry = current_user.watched_project_associations.find(params[:id])
    @watched_project_entry.destroy
    
    flash[:notice] = "Project removed from Watch List"
    
    redirect_to([@user, :watched_project_associations])
  end
  
  private
  
  def find_user
    @user = User.find(params[:user_id])
  end

end
