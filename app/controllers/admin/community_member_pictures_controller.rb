class Admin::CommunityMemberPicturesController < AdminController
  
  before_filter :find_community_member_profile
  
  # GET /community_member_pictures
  # GET /community_member_pictures.xml
  def index
    @project = @community_member_profile.project
    @community_member_pictures = @community_member_profile.pictures

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @community_member_pictures }
    end
  end

  # GET /community_member_pictures/1
  # GET /community_member_pictures/1.xml
  def show
    @community_member_picture = @community_member_profile.pictures.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @community_member_picture }
    end
  end

  # GET /community_member_pictures/new
  # GET /community_member_pictures/new.xml
  def new
    @community_member_picture = @community_member_profile.pictures.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @community_member_picture }
    end
  end

  # GET /community_member_pictures/1/edit
  def edit
    @community_member_picture = @community_member_profile.pictures.find(params[:id])
  end

  # POST /community_member_pictures
  # POST /community_member_pictures.xml
  def create
    @community_member_picture = @community_member_profile.pictures.new(params[:community_member_picture])

    respond_to do |format|
      if @community_member_picture.save
        flash[:notice] = 'CommunityMemberPicture was successfully created.'
        format.html { redirect_to([:admin, @community_member_profile, @community_member_picture]) }
        format.xml  { render :xml => @community_member_picture, :status => :created, :location => @community_member_picture }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @community_member_picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /community_member_pictures/1
  # PUT /community_member_pictures/1.xml
  def update
    @community_member_picture = @community_member_profile.pictures.find(params[:id])

    respond_to do |format|
      if @community_member_picture.update_attributes(params[:community_member_picture])
        flash[:notice] = 'CommunityMemberPicture was successfully updated.'
        format.html { redirect_to([:admin, @community_member_profile, @community_member_picture]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @community_member_picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /community_member_pictures/1
  # DELETE /community_member_pictures/1.xml
  def destroy
    @community_member_picture = @community_member_profile.pictures.find(params[:id])
    @community_member_picture.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, @community_member_profile, :community_member_pictures]) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_community_member_profile
    @community_member_profile = CommunityMemberProfile.find(params[:community_member_profile_id])
  end
end
