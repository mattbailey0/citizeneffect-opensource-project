require 'test_helper'

class Api::V1::PartnersControllerTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
    @user.roles.add!(Role.partner_admin)
    @user.reload
    @user.enable_api!
    @partner = Factory(:partner)
    @partner.logo = Factory.create("unified_upload", :flavor => "Partner_logo")
  end
  
  test "should get show in json format" do
    get :show, :format => 'json', :id => @partner.id, :api_key => @user.api_key
    assert_response :success
    assert JSON.parse(@response.body)["name"] == @partner.display_name
    assert !(JSON.parse(@response.body).has_key? "phone_number")
  end

  test "should get show in xml format" do
    get :show, :format => 'xml', :id => @partner.id, :api_key => @user.api_key
    assert_response :success
    assert Hash.from_xml(@response.body)['partner']['name'] == @partner.display_name
    assert !(Hash.from_xml(@response.body)['partner'].has_key? "phone_number")
  end

  test "should return a 404 if the partner id does not exist" do
    get :show, :format => 'json', :id => 'omg id', :api_key => @user.api_key
    assert_response 404
  end

  test "should return a 400 if the user id was not supplied" do
    get :show, :format => 'json', :api_key => @user.api_key
    assert_response 400
  end
end
