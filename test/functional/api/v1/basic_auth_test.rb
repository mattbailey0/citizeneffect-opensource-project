require 'test_helper'

class Api::V1::BasicAuthTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
    @user.roles.add!(Role.partner_admin)
    @user.reload
    @user.enable_api!
    @controller = Api::V1::ProjectsController.new
  end

  test "should get the index in json format using basic auth" do
    @request.env['HTTP_AUTHORIZATION'] = 
      ActionController::HttpAuthentication::Basic.encode_credentials(@user.api_key, '')
      
    @project = Factory(:project, :community_name => 'Awesome')
    3.times { Factory(:project) }
    Project.stubs(:sphinx_user_visible).returns(stub(:search => [@project]))
    get :search, :format => 'json', :search_term => 'Awesome'
    assert_response :success
    assert JSON.parse(@response.body).first["name"] == @project.name
    assert !(JSON.parse(@response.body).first.has_key? "animal_husbandry")
  end

end
