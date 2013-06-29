class Admin::CpApplicationsController < AdminController
  # GET /cp_applications
  # GET /cp_applications.xml
  def index
    @cp_applications = CpApplication.all
    @cp_applications_paginated = CpApplication.all.paginate :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cp_applications }
      format.xls { send_as_xls }
    end
  end

  # GET /cp_applications/1
  # GET /cp_applications/1.xml
  def show
    @cp_application = CpApplication.find(params[:id])
    @approval = Approval.new
    @approvable_association = ApprovableAssociation.new(:approvable => @cp_application, :approval => @approval)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cp_application }
    end
  end

  # GET /cp_applications/new
  # GET /cp_applications/new.xml
  def new
    @cp_application = CpApplication.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cp_application }
    end
  end

  # GET /cp_applications/1/edit
  def edit
    @cp_application = CpApplication.find(params[:id])
  end

  # POST /cp_applications
  # POST /cp_applications.xml
  def create
    @cp_application = CpApplication.new(params[:cp_application])

    respond_to do |format|
      if @cp_application.save
        flash[:notice] = 'CpApplication was successfully created.'
        format.html { redirect_to([:admin, @cp_application]) }
        format.xml  { render :xml => @cp_application, :status => :created, :location => @cp_application }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cp_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cp_applications/1
  # PUT /cp_applications/1.xml
  def update
    @cp_application = CpApplication.find(params[:id])

    respond_to do |format|
      if @cp_application.update_attributes(params[:cp_application])
        flash[:notice] = 'CpApplication was successfully updated.'
        format.html { redirect_to([:admin, @cp_application]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cp_application.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cp_applications/1
  # DELETE /cp_applications/1.xml
  def destroy
    @cp_application = CpApplication.find(params[:id])
    @cp_application.destroy

    respond_to do |format|
      format.html { redirect_to(admin_cp_applications_url) }
      format.xml  { head :ok }
    end
  end
end

