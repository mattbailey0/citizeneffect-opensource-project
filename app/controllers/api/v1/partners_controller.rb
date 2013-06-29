class Api::V1::PartnersController < ApplicationController
  before_filter :login_required
  before_filter :find_campaign
  
  # GET /partners.xml
  # GET /partners.json
  def index
      if params[:user_id]
      @partners = Partner.find(:all, :conditions => {:cp_id => params[:user_id]}
      )
    else
      @partners = @campaign ? @campaign.partners : Partner.find(:all)
    end

    respond_to do |format|
      if params[:user_id] && !User.exists?(params[:user_id])
        format.json { render :json => { :error => "User with ID #{params[:user_id]} Not Found" }, :status => 404 }
        format.xml { render :xml => "<error>User with ID #{params[:user_id]} Not Found</error>", :status => 404 }
      else
        format.json { render :action => "index" }
        format.xml  { render :action => "index" }
      end
    end

  end


  # GET /partners/1.xml
  # GET /partners/1.json
  def show
    @partner = Partner.find_by_id(params[:id])
    respond_to do |format|
      if params[:id].blank?
        format.json { render :json => { :error => "No ID provided" }, :status => 400 }
        format.xml { render :xml => "<error>No ID provided</error>", :status => 400 }
      elsif @partner.blank?
        format.json { render :json => { :error => "Partner with ID #{params[:id]} Not Found" }, :status => 404 }
        format.xml { render :xml => "<error>Partner with ID #{params[:id]} Not Found</error>", :status => 404 }
      else
        format.json { render :action => "show" }
        format.xml  { render :action => "show" }
      end
    end
  end
  
  private
  def find_campaign
      @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
  end
end

