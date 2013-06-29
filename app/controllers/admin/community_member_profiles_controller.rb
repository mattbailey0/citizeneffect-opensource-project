class Admin::CommunityMemberProfilesController < AdminController  
  include CommunityMemberProfilesHelper
  
  before_filter :find_project
#  before_filter :find_project_report

  # GET /community_member_profiles
  def index
    @community_member_profiles = @project.community_member_profiles
  end

  # GET /community_member_profiles/1
  def show
    @community_member_profile = @project.community_member_profiles.find(params[:id])
  end

  # GET /community_member_profiles/new
  def new
    @community_member_profile = CommunityMemberProfile.new
    @community_member_profile.build_profile_picture unless @community_member_profile.profile_picture
  end

  # GET /community_member_profiles/1/edit
  def edit
    @community_member_profile = @project.community_member_profiles.find(params[:id])
  end

  # POST /community_member_profiles
  def create
    @community_member_profile = @project.community_member_profiles.build(params[:community_member_profile])
    @community_member_profile.build_profile_picture unless @community_member_profile.profile_picture


    if @community_member_profile.save
      flash[:notice] = 'Community Member Profile was successfully created.'
      redirect_to(admin_project_community_member_profile_path(@project, @community_member_profile))
    else
      render :action => "new"
    end
  end

  # PUT /community_member_profiles/1
  def update
    @community_member_profile = @project.community_member_profiles.find(params[:id])
    @community_member_profile.build_profile_picture unless @community_member_profile.profile_picture

    if @community_member_profile.update_attributes(params[:community_member_profile])
      flash[:notice] = 'Community Member Profile was successfully updated.'
      redirect_to(admin_project_community_member_profile_path(@project, @community_member_profile))
    else
      render :action => "edit"
    end
  end

  # DELETE /community_member_profiles/1
  def destroy
    @community_member_profile = @project.community_member_profiles.find(params[:id])
    @community_member_profile.destroy

    redirect_to(admin_project_community_member_profiles_path(@project))
  end
  
  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
  
#   def find_project_report
#     if params[:project_report_type] && params[:project_report_id]
#       @project_report = @project.send(params[:project_report_type].tableize).find(params[:project_report_id])
# #     elsif params[:project_report]
# #       @project_report = @project.send(params[:project_report][:type].tableize).find(params[:project_report][:id])
#     else
#       @project_report = nil
#     end
#   end
end
