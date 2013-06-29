class Api::V1::CampaignsController < ApplicationController
  before_filter :login_required

  # GET /campaigns.json
  # GET /campaigns.xml
  def index
    @campaigns = Campaign.all
    respond_to do |format|
      format.json { render :action => "index" }
      format.xml { render :action => "index" }
    end
  end

  # GET /campaigns/1.xml
  # GET /campaigns/1.json
  def show
    @campaign = Campaign.find_by_id(params[:id])
    respond_to do |format|
      if params[:id].blank?
        format.json { render :json => { :error => "No ID provided" }, :status => 400 }
        format.xml { render :xml => "<error>No ID provided</error>", :status => 400 }
      elsif @campaign.blank?
        format.json { render :json => { :error => "Campaign with ID #{params[:id]} Not Found" }, :status => 404 }
        format.xml { render :xml => "<error>Campaign with ID #{params[:id]} Not Found</error>", :status => 404 }
      else
        format.json { render :action => "show" }
        format.xml  { render :action => "show" }
      end
    end
  end
end

