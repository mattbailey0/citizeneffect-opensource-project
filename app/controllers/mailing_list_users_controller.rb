class MailingListUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def new
    @mailing_list = MailingList.find(params[:mailing_list_id])
    @mailing_list_user = @mailing_list.subscribers.build(params[:mailing_list_user])
  end

  # POST /mailing_list_users
  def create
    @mailing_list = MailingList.find(params[:mailing_list_id])
    # look up MLU first by user so we don't violate that uniqueness
    @user = User.find_by_email(params[:mailing_list_user].andand[:email])
    @mailing_list_user = @mailing_list.subscribers.find_by_user_id(@user.id) if @user
    @mailing_list_user ||= @mailing_list.subscribers.find_or_initialize_by_email(params[:mailing_list_user].andand[:email])
    
    if @mailing_list_user.update_attributes(params[:mailing_list_user])
    
      will_redirect_to = @mailing_list.project || if !@mailing_list_user.tracking_code.blank?
                                                    thanks_mailing_list_users_path
                                                  elsif current_user
                                                    home_index_path
                                                  else
                                                    signup_path
                                                  end
      
      flash[:notice] = "Subscribed to email list successfully.#{will_redirect_to == signup_path ? ' Continue by making an account below (it\'s easy)!' : ''}"
      redirect_to(will_redirect_to)
    else
      flash[:error] = "Unable to subscribe to email list.  #{@mailing_list_user.errors.full_messages.to_sentence}."
      redirect_to :back
    end
  end
  
  def thanks
    @project = Project.needing_donations.random.first
  end

  # DELETE /mailing_list_users/1
  def destroy
    @mailing_list_user = MailingListUser.find_by_unsubscribe_token(params[:id]) ||
      current_user.andand.mailing_list_users.andand.find_by_id(params[:id])

    destination = @mailing_list_user.andand.mailing_list.andand.project
    destination = current_user if(params[:return_to] == "user")
    
    @mailing_list_user.andand.destroy
    
    flash[:notice] = "You have successfully unsubscribed from this mailing list."

    redirect_to(destination || home_index_path)
  end
  alias :unsubscribe :destroy
  
end
