class MessagesController < ApplicationController
  
  before_filter :set_user
  before_filter :require_admin_or_match_given_user
  
  def index
    if params[:mailbox] == "sent"
      @messages = @user.sent_messages
      render :action => "sent"
    else
      @messages = @user.received_messages
      render :action => "inbox"
    end
  end
  
  def show
    @message = Message.read(params[:id], @user)
  end
  
  def new
    @message = Message.new
    if params[:reply_to]
      @reply_to = @user.received_messages.find(params[:reply_to])
      unless @reply_to.nil?
        @message.recipient = @reply_to.sender
        @message.to = @reply_to.sender.email
        @message.subject = "Re: #{@reply_to.subject}"
        @message.body = "\n\n*Original message*\n\n #{@reply_to.body}"
      end
    elsif params[:to]
      @message.recipient = User.find(params[:to])
    end
  end
  
  def create
    @message = Message.new(params[:message])
    @message.sender = @user

    if @message.save
      flash[:notice] = "Message successfully sent to #{CGI.escapeHTML @message.recipient.andand.display_name}"
      redirect_to user_messages_path(@user)
    else
      render :action => :new
    end
  end
  
  def destroy
    @message = Message.find(:first, :conditions => 
                         ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", params[:id], @user, @user])    
    
    @message.mark_deleted(@user) unless @message.nil?
    flash[:notice] = "Message deleted"
    
    redirect_to :back
  end
  
  private
  def set_user
    @user = User.find(params[:user_id])
  end
end
