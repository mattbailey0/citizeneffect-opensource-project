class Admin::CommunityMemberAudiosController < AdminController
  
  before_filter :find_community_member_profile
  
  # GET /community_member_audios
  # GET /community_member_audios.xml
  def index
    @project = @community_member_profile.project
    @community_member_audios = @community_member_profile.audios

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @community_member_audios }
    end
  end

  # GET /community_member_audios/1
  # GET /community_member_audios/1.xml
  def show
    @community_member_audio = @community_member_profile.audios.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @community_member_audio }
    end
  end

  # GET /community_member_audios/new
  # GET /community_member_audios/new.xml
  def new
    @community_member_audio = @community_member_profile.audios.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @community_member_audio }
    end
  end

  # GET /community_member_audios/1/edit
  def edit
    @community_member_audio = @community_member_profile.audios.find(params[:id])
  end

  # POST /community_member_audios
  # POST /community_member_audios.xml
  def create
    @community_member_audio = @community_member_profile.audios.new(params[:community_member_audio])

    respond_to do |format|
      if @community_member_audio.save
        flash[:notice] = 'CommunityMemberAudio was successfully created.'
        format.html { redirect_to([:admin, @community_member_profile, @community_member_audio]) }
        format.xml  { render :xml => @community_member_audio, :status => :created, :location => @community_member_audio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @community_member_audio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /community_member_audios/1
  # PUT /community_member_audios/1.xml
  def update
    @community_member_audio = @community_member_profile.audios.find(params[:id])

    respond_to do |format|
      if @community_member_audio.update_attributes(params[:community_member_audio])
        flash[:notice] = 'CommunityMemberAudio was successfully updated.'
        format.html { redirect_to([:admin, @community_member_profile, @community_member_audio]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @community_member_audio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /community_member_audios/1
  # DELETE /community_member_audios/1.xml
  def destroy
    @community_member_audio = @community_member_profile.audios.find(params[:id])
    @community_member_audio.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, @community_member_profile, :community_member_audios]) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_community_member_profile
    @community_member_profile = CommunityMemberProfile.find(params[:community_member_profile_id])
  end
end
