class Admin::CommunityMemberVideosController < AdminController
  
  before_filter :find_community_member_profile
  before_filter :find_project, :only => [:index, :show]

  # GET /community_member_videos
  # GET /community_member_videos.xml
  def index
    @community_member_videos = @community_member_profile.videos

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @community_member_videos }
    end
  end

  # GET /community_member_videos/1
  # GET /community_member_videos/1.xml
  def show
    @community_member_video = @community_member_profile.videos.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @community_member_video }
    end
  end

  # GET /community_member_videos/new
  # GET /community_member_videos/new.xml
  def new
    @community_member_video = @community_member_profile.videos.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @community_member_video }
    end
  end

  # GET /community_member_videos/1/edit
  def edit
    @community_member_video = @community_member_profile.videos.find(params[:id])
  end

  # POST /community_member_videos
  # POST /community_member_videos.xml
  def create
    @community_member_video = @community_member_profile.videos.new(params[:community_member_video])

    respond_to do |format|
      if @community_member_video.save
        flash[:notice] = 'CommunityMemberVideo was successfully created.'
        format.html { redirect_to([:admin, @community_member_profile, @community_member_video]) }
        format.xml  { render :xml => @community_member_video, :status => :created, :location => @community_member_video }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @community_member_video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /community_member_videos/1
  # PUT /community_member_videos/1.xml
  def update
    @community_member_video = @community_member_profile.videos.find(params[:id])

    respond_to do |format|
      if @community_member_video.update_attributes(params[:community_member_video])
        flash[:notice] = 'CommunityMemberVideo was successfully updated.'
        format.html { redirect_to([:admin, @community_member_profile, @community_member_video]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @community_member_video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /community_member_videos/1
  # DELETE /community_member_videos/1.xml
  def destroy
    @community_member_video = @community_member_profile.videos.find(params[:id])
    @community_member_video.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, @community_member_profile, :community_member_videos]) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_community_member_profile
    @community_member_profile = CommunityMemberProfile.find(params[:community_member_profile_id])
  end
  
  def find_project
    @project = @community_member_profile.project
  end
end
