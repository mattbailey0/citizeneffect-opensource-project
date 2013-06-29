class Admin::SubscribersController < AdminController
  # GET /subscribers
  # GET /subscribers.xml
  def index
    @mailing_lists = MailingList.all
    #@mailing_lists_paginated = MailingList.all.paginate :page => params[:page] #no pagination for the moment - need to rework interface more thoroughly.

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mailing_lists }
      format.xls { send_as_xls }
    end
  end
end

