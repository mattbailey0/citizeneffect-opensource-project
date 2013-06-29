class Admin::CommunityMemberMessagesController < AdminController
  
  before_filter :find_community_member_profile
  
  # GET /community_member_messages
  # GET /community_member_messages.xml
  def index
    @project = @community_member_profile.project
    @community_member_messages = @community_member_profile.messages
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @community_member_messages }
    end
  end

  # GET /community_member_messages/1
  # GET /community_member_messages/1.xml
  def show
    @community_member_message = @community_member_profile.messages.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @community_member_message }
    end
  end

  # GET /community_member_messages/new
  # GET /community_member_messages/new.xml
  def new
    @community_member_message = @community_member_profile.messages.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @community_member_message }
    end
  end

  # GET /community_member_messages/1/edit
  def edit
    @community_member_message = @community_member_profile.messages.find(params[:id])
  end

  # POST /community_member_messages
  # POST /community_member_messages.xml
  def create
    @community_member_message = @community_member_profile.messages.new(params[:community_member_message])

    respond_to do |format|
      if @community_member_message.save
        flash[:notice] = 'Community Member Message was successfully created.'
        format.html { redirect_to([:admin, @community_member_profile, @community_member_message]) }
        format.xml  { render :xml => @community_member_message, :status => :created, :location => @community_member_message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @community_member_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /community_member_messages/1
  # PUT /community_member_messages/1.xml
  def update
    @community_member_message = @community_member_profile.messages.find(params[:id])

    respond_to do |format|
      if @community_member_message.update_attributes(params[:community_member_message])
        flash[:notice] = 'Community Member Message was successfully updated.'
        format.html { redirect_to([:admin, @community_member_profile, @community_member_message]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @community_member_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /community_member_messages/1
  # DELETE /community_member_messages/1.xml
  def destroy
    @community_member_message = @community_member_profile.messages.find(params[:id])
    @community_member_message.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, @community_member_profile, :community_member_messages]) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_community_member_profile
    @community_member_profile = CommunityMemberProfile.find(params[:community_member_profile_id])
  end
end
