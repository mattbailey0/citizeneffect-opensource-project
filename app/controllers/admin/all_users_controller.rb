class Admin::AllUsersController < AdminController
  # GET /all_users
  # GET /all_users.xml
  def index
    @conditionFields = "(last_name LIKE '%#{params[:search]}%' OR first_name LIKE '%#{params[:search]}%' OR email LIKE '%#{params[:search]}%')"
    
    if params[:year] && params[:year] != ""
     @conditionFields += 'AND DATE_FORMAT(created_at, "%Y") = ' + params[:year] 
    end
    #@users = User.all
    @users_paginated = User.paginate(:page => params[:page],
                                        :conditions => @conditionFields,
                                        :order => 'last_name ASC')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
      format.xls { send_as_xls }
    end
  end

  def search


  end

end

