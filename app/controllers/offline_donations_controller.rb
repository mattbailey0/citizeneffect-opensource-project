class OfflineDonationsController < ApplicationController

  before_filter :find_project
  before_filter :require_citizen_effect_admin
  
  # GET /donations
  def index
    @donations = @project.offline_donations
  end

  # GET /donations/new
  def new
    @donation = Donation.new(:project => @project)
    render :action => "edit"
  end

  # GET /donations/1/edit
  def edit
    @donation = @project.offline_donations.find(params[:id])
  end

  # POST /donations
  def create
    @donation = Donation.new(params[:donation])
    @donation.project = @project
    @donation.donation_cp = current_user
    @donation.offline = true
    
    if @donation.save
      flash[:notice] = 'Offline donation was successfully created.'
      redirect_to project_offline_donations_path(@project)
    else
      render :action => "edit"
    end
  end

  # PUT /donations/1
  def update
    @donation = @project.offline_donations.find(params[:id])

    if @donation.update_attributes(params[:donation])
      flash[:notice] = 'Offline donation was successfully updated.'
      redirect_to project_offline_donations_path(@project)
    else
      render :action => "edit"
    end
  end

  # DELETE /donations/1
  def destroy
    @donation = @project.offline_donations.find(params[:id])
    @donation.destroy

    flash[:notice] = 'Offline donation was successfully deleted.'
    redirect_to project_offline_donations_path(@project)
  end
  
  private
  def find_project
    @project = Project.find(params[:project_id])
  end

end
