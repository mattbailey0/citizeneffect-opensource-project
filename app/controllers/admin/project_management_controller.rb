class Admin::ProjectManagementController < AdminController
  # GET /project_management
  # GET /project_management.xml
  def index
    @conditionFields = ['name LIKE ? AND project_status_id=7',"%#{params[:search]}%"]

    @active_projects = current_user.projects.find :all, :conditions=>"project_status_id=7"
    @active_projects_paginated = current_user.projects.paginate(:page => params[:page],
                                        #:includes => [:project_status],
                                        :conditions => @conditionFields,
                                        :order => "projects.id ASC")

    respond_to do |format|
      format.html
      format.xml  { render :xml => @active_projects_applications }
      format.xls { send_as_xls }
    end
  end


end

