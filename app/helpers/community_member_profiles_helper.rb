module CommunityMemberProfilesHelper
  def new_admin_community_member_profile_with_project_report_path
    new_admin_project_community_member_profile_path(@project, :project_report_id => @project_report.andand.id, :project_report_type => @project_report.andand.class)
  end
  
  def edit_admin_community_member_profile_with_project_report_path(community_member_profile = nil)
    community_member_profile ||= @community_member_profile
    edit_admin_project_community_member_profile_path(@project, community_member_profile, :project_report_id => @project_report.andand.id, :project_report_type => @project_report.andand.class)
  end
  
  def admin_community_member_profile_with_project_report_path(community_member_profile = nil)
    community_member_profile ||= @community_member_profile
    admin_project_community_member_profile_path(@project, community_member_profile, :project_report_id => @project_report.andand.id, :project_report_type => @project_report.andand.class)
  end
  
  def admin_community_member_profiles_with_project_report_path
    admin_project_community_member_profiles_path(@project, :project_report_id => @project_report.andand.id, :project_report_type => @project_report.andand.class)
  end
end
