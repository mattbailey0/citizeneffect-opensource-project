require 'test_helper'

class Api::V1::FeaturedProjectsControllerTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
    @user.roles.add!(Role.partner_admin)
    @user.reload
    @user.enable_api!
  end

  test "should get the index in json format" do
    12.times { Factory(:featured_project) }
    get :index, :format => 'json', :api_key => @user.api_key
    assert JSON.parse(@response.body).size == 10
    assert JSON.parse(@response.body).first["title"] == FeaturedProject.all(:limit => 10).first.title
    assert !(JSON.parse(@response.body).first.has_key? "position")
  end

  test "should get the index in xml format" do
    12.times { Factory(:featured_project) }
    get :index, :format => 'xml', :api_key => @user.api_key    
    assert Hash.from_xml(@response.body)['featured_projects'].size == 10
    assert Hash.from_xml(@response.body)['featured_projects'].first['title'] == FeaturedProject.all(:limit => 10).first.title
    assert !(Hash.from_xml(@response.body)['featured_projects'].first.has_key? "position")
  end

end
