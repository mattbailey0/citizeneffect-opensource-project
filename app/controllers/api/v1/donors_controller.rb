class Api::V1::DonorsController < ApplicationController
  before_filter :login_required
  # GET /donors.xml
  # GET /donors.json
  def index
    @project = Project.find_by_id(params[:project_id])
    @donors = @project.donations.paginate(:per_page => 10, :page => params[:page] || 1) unless @project.blank?

    respond_to do |format|
      if params[:project_id].blank?
        format.json { render :json => { :error => "No Project ID provided" }, :status => 400 }
        format.xml { render :xml => "<error>No Project ID provided</error>", :status => 400 }
      elsif @project.blank?
        format.json { render :json => { :error => "Project with ID #{params[:project_id]} Not Found" }, :status => 404 }
        format.xml { render :xml => "<error>Project with ID #{params[:project_id]} Not Found</error>", :status => 404 }
      else
        format.json { render :json => @donors.collect {|donor| {:name => donor.name, :location => donor.display_location, :created_at => donor.created_at }}.to_json }
        format.xml  { render :action => "index" }
      end
    end

  end
end
