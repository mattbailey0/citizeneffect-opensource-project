class Api::V1::GeneralFormsController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token

  # POST /general_form
  def create

    #does not take into account uniqueness of entry!!!
    @general_form = GeneralForm.new(params[:general_form])
    @general_form.first_name      = params[:first_name]
    @general_form.last_name       = params[:last_name]
    @general_form.email           = params[:email]
    @general_form.phone_number    = params[:phone_number]
    @general_form.location        = params[:location]
    @general_form.location_other  = params[:location_other]
    @general_form.cause           = params[:cause]
    @general_form.referred_by     = params[:referred_by]
    @general_form.comment         = params[:comment]
    @general_form.request         = params[:request]

    if params[:source].blank?
        @source = 'General'
    else
        @source = params[:source]
    end
    @general_form.source = @source

    respond_to do |format|
      if params[:email].blank? || params[:first_name].blank? || params[:last_name].blank?
        format.json { render :json => { :error => "Not enough information provided." }, :status => 400 }
        format.xml { render :xml => "<error>Not enough information provided</error>", :status => 400 }
      elsif @general_form.save
        #format.json { render :action => "create" }
        format.json { render :json => { :response => "Success."},:status => 200 }
        format.xml  { render :action => "create" }
      else
        #format.json { render :json => @mailing_list_user.errors, :status => 400 }
        format.json { render :json => { :error => "Unknown error." }, :status => 400 }
        #format.xml  { render :xml => @mailing_list_user.errors, :status => 400 }
        format.xml { render :xml => "<error>Unknown error.</error>", :status => 400 }
      end
    end
  end
end

