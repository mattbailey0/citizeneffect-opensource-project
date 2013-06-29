class Api::V1::DonationsController < ApplicationController
  # ssl_required :index, :new, :create
  filter_parameter_logging :credit_card_number, :expiration_year, :expiration_month, :credit_card_cvv
  before_filter :get_project
  
  # POST /donations
  def create
    if Time.now.year > 2012
      respond_to do |format|
          format.json { render :json => { :message => "Donation was not processed." }.to_json, :status => 400 }
          format.xml  { render :xml => "<message>Donation was not processed.</message>", :status => 400 }
      end
    else

      @donation = Donation.new(params[:donation])
    
      @donation.project_id = params[:project_id]
      
      @donation.set_fee_percentage
      
      @donation.refunds_total_in_cents = 0
      
      respond_to do |format|
        if @donation.save_and_charge_with_rollback
          format.json { render :json => { :message => "Donation Successful" }.to_json, :status => 200 }
          format.xml  { render :xml => "<message>Donation Successful</message>", :status => 200 }
        else
          format.json { render :json => @donation.errors, :status => 400 }
          format.xml  { render :xml => @donation.errors, :status => 400 }
        end
      end
    end
  end
  
  private
  
  def get_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end
end
