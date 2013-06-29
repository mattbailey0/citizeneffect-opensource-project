class Api::V1::FeaturedProjectsController < ApplicationController
  before_filter :login_required
  # GET /featured_projects
  # GET /featured_projects.xml
  def index
    @featured_projects = FeaturedProject.paginate(:per_page => 10, :page => params[:page] || 1)

    respond_to do |format|
      format.json { render :action => "index" }
      format.xml  { render :action => "index" }
    end
  end
end
