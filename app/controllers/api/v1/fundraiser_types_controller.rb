class Api::V1::FundraiserTypesController < ApplicationController
  before_filter :login_required
  # GET /fundraiser_types.json
  # GET /fundraiser_types.xml
  def index
      @fundraiser_types = FundraiserType.find(:all)    
    respond_to do |format|
      format.json { render :action => "index" }
      format.xml  { render :action => "index" }
    end
  end
end
