class Api::V1::MailingListUsersController < ApplicationController
  before_filter :login_required
  skip_before_filter :verify_authenticity_token
  
  # POST /mailing_list_users
  def create
    @project = Project.find_by_id(params[:project_id])
    unless @project.blank?
      @mailing_list = @project.mailing_list
      # look up MLU first by user so we don't violate that uniqueness
      @user = User.find_by_email(params[:mailing_list_user].andand[:email])
      @mailing_list_user = @mailing_list.subscribers.find_by_user_id(@user.id) if @user
      @mailing_list_user ||= @mailing_list.subscribers.find_or_initialize_by_email(params[:mailing_list_user].andand[:email])
    end
    
    respond_to do |format|
      if params[:project_id].blank?
        format.json { render :json => { :error => "No Project ID provided" }, :status => 400 }
        format.xml { render :xml => "<error>No Project ID provided</error>", :status => 400 }
      elsif @project.blank?
        format.json { render :json => { :error => "Project with ID #{params[:project_id]} Not Found" }, :status => 404 }
        format.xml { render :xml => "<error>Project with ID #{params[:project_id]} Not Found</error>", :status => 404 }
      elsif @mailing_list_user.update_attributes(params[:mailing_list_user])
        format.json { render :action => "create" }
        format.xml  { render :action => "create" }
      else
        format.json { render :json => @mailing_list_user.errors, :status => 400 }
        format.xml  { render :xml => @mailing_list_user.errors, :status => 400 }
      end
    end
  end
end
