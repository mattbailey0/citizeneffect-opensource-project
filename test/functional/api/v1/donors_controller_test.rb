require 'test_helper'

class Api::V1::DonorsControllerTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
    @user.roles.add!(Role.partner_admin)
    @user.reload
    @user.enable_api!
  end

  test "should get index in json format" do
    @project = Factory(:project)
    @donation = Factory(:donation, :project => @project)
    get :index, :format => 'json', :project_id => @project.id, :api_key => @user.api_key
    assert_response :success
    assert JSON.parse(@response.body).first["name"] == @donation.name
    assert !(JSON.parse(@response.body).first.has_key? "actual_amount_in_cents")
  end

  test "should get index in xml format" do
    @project = Factory(:project)
    @donation = Factory(:donation, :project => @project)
    get :index, :format => 'xml', :project_id => @project.id, :api_key => @user.api_key
    assert_response :success
    assert Hash.from_xml(@response.body)['donors'].first['name'] == @donation.name
    assert !(Hash.from_xml(@response.body)['donors'].first.has_key? "actual_amount_in_cents")
  end

  test "should return a 404 if the project id does not exist" do
    get :index, :format => 'json', :project_id => 'omg id', :api_key => @user.api_key
    assert_response 404
  end

  test "should return a 400 if the project id was not supplied" do
    get :index, :format => 'json', :api_key => @user.api_key
    assert_response 400
  end

end
