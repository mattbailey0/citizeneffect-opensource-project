require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
    @user.roles.add!(Role.partner_admin)
    @user.reload
    @user.enable_api!
  end

  test "should post to make a user in json format" do
    post :create, :format => 'json', :user => user_hash, :api_key => @user.api_key
    assert_response :success
    content = JSON.parse(@response.body)
    assert content['email'] == 'first@example.com'
  end

  test "should post to make a user in xml format" do
    post :create, :format => 'xml', :user => user_hash, :api_key => @user.api_key
    assert_response :success
    assert_select 'email', :text => 'first@example.com'
  end

  test "should return a 400 if attempting to make user with incomplete data" do
    post :create, :format => 'xml', :user => user_hash.merge(:email => nil), :api_key => @user.api_key
    assert_response 400
  end

  test "should return a 400 if attempting to make user with invalid data" do
    post :create, :format => 'xml', :user => user_hash.merge(:email => 'lolwut'), :api_key => @user.api_key
    assert_response 400
  end
  
  test "should get show in json format" do
    get :show, :format => 'json', :id => @user.id, :api_key => @user.api_key
    assert_response :success
    assert JSON.parse(@response.body)["name"] == @user.name
    assert !(JSON.parse(@response.body).has_key? "password")
  end

  test "should get show in xml format" do
    get :show, :format => 'xml', :id => @user.id, :api_key => @user.api_key
    assert_response :success
    assert Hash.from_xml(@response.body)['user']['name'] == @user.name
    assert !(Hash.from_xml(@response.body)['user'].has_key? "password")
  end

  test "should return a 404 if the user id does not exist" do
    get :show, :format => 'json', :id => 'omg id', :api_key => @user.api_key
    assert_response 404
  end

  test "should return a 400 if the user id was not supplied" do
    get :show, :format => 'json', :api_key => @user.api_key
    assert_response 400
  end

  def user_hash
    {
      :first_name => "First Name",
      :last_name => "Last Name",
      :zip => '46260',
      :email => 'first@example.com',
      :password => 'awesome',
      :password_confirmation => 'awesome',
    }
  end

end
