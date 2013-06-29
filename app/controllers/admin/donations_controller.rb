class Admin::DonationsController < AdminController

  before_filter :find_project

  def index
    @conditionFields = ['last_name LIKE ? OR
                          first_name LIKE ? OR
                          email LIKE ? OR
                          address1 LIKE ? OR
                          city LIKE ? OR
                          state LIKE ?
                          ',
                        "%#{params[:search]}%",
                        "%#{params[:search]}%",
                        "%#{params[:search]}%",
                        "%#{params[:search]}%",
                        "%#{params[:search]}%",
                        "%#{params[:search]}%"];
    @year_filter = params[:year] ? 'DATE_FORMAT(donated_at, "%Y") = ' + params[:year] : ''
    @donations = @project ? @project.donations : Donation.find(:all,:conditions => @year_filter)
    @donations_paginated = @project ? @project.donations.paginate(:page => params[:page],
                                        :conditions => @conditionFields,
                                        :order => 'donated_at DESC'):
                          Donation.paginate(:page => params[:page],
                                        :conditions => @conditionFields,
                                        :order => 'donated_at DESC')
                            
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @donations }
      format.xls { send_as_xls }
    end
  end

  def new
    @donation = (@project ? @project.donations : Donation).new
  end

  def edit
    @donation = Donation.find(params[:id])
  end

  def create
    @donation = (@project ? @project.donations : Donation).new(params[:donation])
    @donation.offline = true
    
    if @donation.save
      flash[:notice] = 'Donation was successfully created.'
      redirect_to [:edit, :admin, @project, @donation].compact
    else
      render :action => "new"
    end
  end

  def update
    @donation = Donation.find(params[:id])

    if @donation.update_attributes(params[:donation])
      flash[:notice] = 'Donation was successfully updated.'
      redirect_to [:edit, :admin, @project, @donation].compact
    else
      render :action => "edit"
    end
  end

  def destroy
    @donation = Donation.find(params[:id])
    @donation.andand.destroy

    redirect_to admin_donations_path(:project_id => @project.andand.id)
  end

  private
  def find_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end
end

