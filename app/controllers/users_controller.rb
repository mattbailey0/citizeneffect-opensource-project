class UsersController < ApplicationController
  ssl_required :edit, :update, :new, :create
  ssl_allowed :push_status # coming from an ssl page, we don't want to mess up the :back redirect

  before_filter :find_user
  before_filter :require_admin_or_match_given_user, :only => [:update, :edit, :push_status]
  skip_after_filter :store_get_request_location, :except => [:show, :edit, :update, :message]


  # render new.rhtml
  def new
    @user = User.new(:referral_code => params[:referral_code])
  end

  def show
    render :action => "show"
  end
  alias :show_projects  :show
  alias :show_donations :show

  def edit
  end

  def update
    case params[:commit]
      when "picture":
        notice_msg = "Picture successfully updated."
      when "social-media-links":
        notice_msg = "Social media links successfully updated."
      when "account-information":
        notice_msg = "Account information successfully updated."
      when "about-me"
        notice_msg = "About me successfully updated."
      when "todo-item":
        notice_msg = "Item removed from todo list."
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = notice_msg || 'User was successfully updated.'
      redirect_to(@user)
    else
      render :action => "edit"
    end
  end

  def push_status
    if params[:status][:message].blank?
      flash[:error] = "Cannot share blank message."
    else
      @user.push_twitter_status(params[:status][:message]) if(params[:status][:push_twitter] == "1")
      @user.push_facebook_status(params[:status][:message]) if(params[:status][:push_facebook] == "1")
      @user.push_myspace_status(params[:status][:message]) if(params[:status][:push_myspace] == "1")
      flash[:notice] = "Message successfully shared."
    end

    redirect_to :back rescue redirect_to home_index_path
  end

  def forgot_password
    if current_user
      flash[:notice] = "You are already logged in - you can set your password here."
      redirect_to edit_user_path(current_user)
    elsif params[:email]
      user = User.find_by_email(params[:email])
      if user
        user.reset_password
        flash[:notice] = "Password reset and email sent! Check your email and then log in with the new password."
        redirect_to login_path
      else
        flash[:error] = "We were unable to find a user account with that email address."
        render :action => "forgot_password"
      end
    else
      render :action => "forgot_password"
    end
  end

  def active_projects
    @projects = @user.projects_in_progress
    @news_items = NewsItem.for_projects(@projects.map(&:id)).top_12.all
  end

  def active_projects_news_items
    @news_items = @user.news_feed_for_active_projects.paginate(:page => params[:page],
                                                               :order => "created_at DESC", :per_page => 12)
    render :update do |page|
      page << "$('#news_items .last').removeClass('last')" unless @news_items.empty?
      page.insert_html :bottom, "news_items", :partial => "shared/news_item", :collection => @news_items,
                       :locals => { :last => @news_items.last}
    end
  end

  def projects_news_items
    @news_items = @user.news_feed_for_cped_projects.paginate(:page => params[:page],
                                                             :order => "created_at DESC", :per_page => 5)
    render :update do |page|
      page << "$('#news_items .last').removeClass('last')" unless @news_items.empty?
      page.insert_html :bottom, "news_items", :partial => "shared/news_item", :collection => @news_items,
                       :locals => { :last => @news_items.last}
    end
  end

  def cps_supported
    @cps_supported = @user.cps_supported.paginate(:page => params[:page], :order => "created_at DESC",
                                                  :per_page => 5)
    render :update do |page|
      page << "$('#cps_supported .last').removeClass('last')" unless @cps_supported.empty?
      page.insert_html :bottom, "cps_supported", :partial => "shared/user_right_message",
                       :collection => @cps_supported, :locals => { :last => @cps_supported.last}
    end
  end

  def projects_donated_to
    @projects_donated_to = params[:anonymous] ?
      @user.projects_with_a_cp_donated_to_anonymously.paginate(:page => params[:page],:per_page => 2) :
      @user.projects_with_a_cp_donated_to.paginate(:page => params[:page], :per_page => 2)

    render :update do |page|
      page << "$('#projects_donated_to .last').removeClass('last')" unless @projects_donated_to.empty?
      page.insert_html :bottom, params[:anonymous] ? "projects_donated_to_anonymously" : "projects_donated_to",
      :partial => "users/project_donated_to",
      :collection => @projects_donated_to, :locals => { :last => @projects_donated_to.last}
    end
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      session[:user_id] = @user.id #log the user in
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
      redirect_back_or_default(user_path(@user))
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin."
      render :action => 'new'
    end
  end

  def activate
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
      when (!params[:activation_code].blank?) && user && !user.active?
        user.activate!
        if user == current_user
          flash[:notice] = "Signup complete!"
          redirect_back_or_default
        else
          logout_keeping_session!
          flash[:notice] = "Signup complete! Please sign in to continue."
          redirect_to login_path
        end
      when params[:activation_code].blank?
        flash[:error] = "The activation code was missing.  Please follow the URL from your email."
        redirect_back_or_default
      when user
        flash[:error] = "You have already activated your account -- try signing in."
        redirect_to (current_user ? home_index_path : login_path)
      else
        flash[:error]  = "We couldn't find a user with that activation code."
        redirect_back_or_default
    end
  end

  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

  def link_to_twitter
    oauth = Twitter::OAuth.new(TWITTER_CONSUMER_TOKEN, TWITTER_CONSUMER_SECRET)

    oauth.set_callback_url(twitter_callback_user_url(current_user))

    session[:twitter_unauth_token] = {
      :token  => oauth.request_token.token,
      :secret => oauth.request_token.secret }

    redirect_to oauth.request_token.authorize_url
  end

  def twitter_callback
    if current_user.andand.id.to_s != params[:id] || session[:twitter_unauth_token] == nil
      flash[:error] = "Invalid twitter access!"
    else
      oauth = Twitter::OAuth.new(TWITTER_CONSUMER_TOKEN, TWITTER_CONSUMER_SECRET)
      oauth.authorize_from_request(session[:twitter_unauth_token][:token],
                                   session[:twitter_unauth_token][:secret],
                                   params[:oauth_verifier])

      current_user.twitter_access_key = oauth.access_token.token
      current_user.twitter_secret_key = oauth.access_token.secret
      current_user.save

      flash[:notice] = "User Account Linked To Twitter!"
    end

    session[:twitter_unauth_token] = nil
    redirect_to current_user ? [:edit, current_user] : home_index_path
  end

  def link_to_myspace
    myspace = MySpace::MySpace.new(MYSPACE_CONSUMER_TOKEN, MYSPACE_CONSUMER_SECRET)
    request_token = myspace.get_request_token
    session[:myspace_unauth_token] = {:token => request_token.token, :secret => request_token.secret}

    redirect_to myspace.get_authorization_url(request_token, myspace_callback_user_url(current_user))
  end

  def myspace_callback
    if current_user.andand.id.to_s != params[:id] || session[:myspace_unauth_token] == nil
      flash[:error] = "Invalid myspace access!"
    else
      myspace = MySpace::MySpace.new(MYSPACE_CONSUMER_TOKEN, MYSPACE_CONSUMER_SECRET,
                                     :request_token => session[:myspace_unauth_token][:token],
                                     :request_token_secret => session[:myspace_unauth_token][:secret])

      access_token = myspace.get_access_token
      current_user.myspace_access_key = access_token.token
      current_user.myspace_secret_key = access_token.secret
      current_user.save

      puts myspace.get_userid
      myspace.set_status(myspace.get_userid, "Test Status")

      flash[:notice] = "User Account Linked To Myspace!"
    end

    session[:myspace_unauth_token] = nil
    redirect_to current_user ? [:edit, current_user] : home_index_path
  end

  def link_to_facebook
    if current_user.andand.id.to_s != params[:id]
      flash[:error] = "Invalid facebook access!"
      redirect_to home_index_path
    else
      redirect_to Facebook.get_redirect_path(facebook_callback_url)
    end
  end

  def facebook_callback
    if params[:code] && current_user
      token = Facebook.get_token(params[:code], facebook_callback_url)
      if token && current_user.update_attributes(:facebook_auth_token => token)
        flash[:notice] = "User Account Linked To Facebook!"
      else
        flash[:error] = "Unable to link account with Facebook"
      end
    else
      flash[:error] = "Unable to link account with Facebook"
    end
    redirect_to current_user ? [:edit, current_user] : home_index_path
  end

  def message
    if current_user
      redirect_to new_user_message_path(:user_id => current_user.id, :to => @user.id)
    else
      flash[:notice] = "You must be logged in to message another user."
      redirect_to login_path
    end
  end

  def generate_api_key
    if @user.can_access_api?
      @user.enable_api!
      flash[:notice] = "API key generated!"
      redirect_to [:edit, @user]
    else
      flash[:error] = "Unable to generate API key"
      redirect_to [:edit, @user]
    end
  end

protected

  def find_user
    @user = User.find(params[:id]) if params[:id]
  end
end

