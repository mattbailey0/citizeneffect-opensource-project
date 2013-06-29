class MailingListEmailsController < ApplicationController
  
  before_filter :find_mailing_list
  before_filter :require_mailing_list_permission
  
  # GET /mailing_list_emails
  def index
    redirect_to [:new, @mailing_list, :mailing_list_email]
  end
  
  # GET /mailing_list_emails/new
  def new
    @mailing_list_email = @mailing_list.mailing_list_emails.build
  end

  # GET /mailing_list_emails/1/edit
  def edit
    @mailing_list_email = @mailing_list.mailing_list_emails.find(params[:id])
  end

  # POST /mailing_list_emails
  def create
    @mailing_list_email = @mailing_list.mailing_list_emails.build(params[:mailing_list_email])
    @mailing_list_email.sender = current_user

    shouldnt_send = !params["send.x"]
    
    if @mailing_list_email.save && (shouldnt_send || @mailing_list_email.send!)
      flash[:notice] = "Email #{shouldnt_send ? "draft " : ""}was successfully #{shouldnt_send ? "saved" : "sent"}."
      dest = if shouldnt_send
               [:edit, @mailing_list, @mailing_list_email]
             else
               @mailing_list.project || [:new, @mailing_list, :mailing_list_email]
             end
      redirect_to dest
    else
      render :action => "new"
    end
  end

  # PUT /mailing_list_emails/1
  def update
    @mailing_list_email = @mailing_list.mailing_list_emails.find(params[:id])
    @mailing_list_email.sender = current_user

    shouldnt_send = !params["send.x"]

    if @mailing_list_email.update_attributes(params[:mailing_list_email]) && (shouldnt_send || @mailing_list_email.send!)
      flash[:notice] = "Email #{shouldnt_send ? "draft " : ""}was successfully #{shouldnt_send ? "saved" : "sent"}."
      redirect_to(shouldnt_send ? [:edit, @mailing_list, @mailing_list_email] : @mailing_list.project) 
    else
      render :action => "edit"
    end
  end

  # DELETE /mailing_list_emails/1
  def destroy
    @mailing_list_email = @mailing_list.mailing_list_emails.find(params[:id])
    @mailing_list_email.destroy

    redirect_to([@mailing_list, :mailing_list_emails])
  end
  
  private
  
  def find_mailing_list
    @mailing_list = MailingList.find(params[:mailing_list_id])
  end
  
  def require_mailing_list_permission
    if @mailing_list.project
      @project = @mailing_list.project
      require_cp_for_project
    else
      require_citizen_effect_admin
    end
  end
  
end
