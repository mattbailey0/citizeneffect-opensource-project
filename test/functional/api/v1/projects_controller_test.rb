require 'test_helper'
require 'pp'
class Api::V1::ProjectsControllerTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
    @user.roles.add!(Role.partner_admin)
    @user.reload
    @user.enable_api!
  end
  
  test "should get index in json format" do
    @project = Factory(:project, :community_name => 'Awesome')
    12.times { Factory(:project) }
    get :index, :format => 'json', :api_key => @user.api_key
    assert_response :success
    assert JSON.parse(@response.body).first["name"] == @project.name
    assert !(JSON.parse(@response.body).first.has_key? "animal_husbandry")
  end

  test "should get index in xml format" do
    @project = Factory(:project, :community_name => 'Awesome')
    12.times { Factory(:project) }
    get :index, :format => 'xml', :api_key => @user.api_key
    assert_response :success
    assert Hash.from_xml(@response.body)['projects'].first['name'] == @project.name
    assert !(Hash.from_xml(@response.body)['projects'].first.has_key? "animal_husbandry")
  end

  test "should get projects belonging to a user when given a user_id in json format" do
    @cp = Factory(:cp)
    @project = Factory(:project, :community_name => 'Awesome')
    12.times { Factory(:project, :cp_id => @cp.id) }
    get :index, :format => 'json', :user_id => @cp.id, :api_key => @user.api_key
    assert_response :success
    content = JSON.parse(@response.body)
    assert content.first["cp_id"] == @cp.id
    assert !content.map {|p| p["community_name"] }.include?(@project.community_name)
  end 

  test "should get projects belonging to a user when given a user_id in xml format" do
    @cp = Factory(:cp)
    @project = Factory(:project, :community_name => 'Awesome')
    12.times { Factory(:project, :cp_id => @cp.id) }
    get :index, :format => 'xml', :user_id => @cp.id, :api_key => @user.api_key
    assert_response :success
    content = Hash.from_xml(@response.body)['projects']
    assert content.first['cp_id'] == @cp.id
    assert !content.map {|p| p["community_name"] }.include?(@project.community_name)
  end

  test "should return a 404 if the user id does not exist" do
    get :index, :format => 'json', :user_id => 'omg id', :api_key => @user.api_key
    assert_response 404
  end  
  
  test "should get show in json format" do
    @project = Factory(:project, :community_name => 'Awesome')
    get :show, :format => 'json', :id => @project.id, :api_key => @user.api_key
    assert_response :success
    assert JSON.parse(@response.body)["name"] == @project.name
    assert !(JSON.parse(@response.body).has_key? "animal_husbandry")
  end

  test "should get show in xml format" do
    @project = Factory(:project, :community_name => 'Awesome')
    get :show, :format => 'xml', :id => @project.id, :api_key => @user.api_key
    assert_response :success
    assert Hash.from_xml(@response.body)['project']['name'] == @project.name
    assert !(Hash.from_xml(@response.body)['project'].has_key? "animal_husbandry")
  end

  test "should return a 404 if the project id does not exist" do
    get :show, :format => 'json', :id => 'omg id', :api_key => @user.api_key
    assert_response 404
  end

  test "should return a 400 if the project id was not supplied" do
    get :show, :format => 'json', :api_key => @user.api_key
    assert_response 400
  end  

  test "should get search results in json format" do
    @project = Factory(:project, :community_name => 'Awesome')
    3.times { Factory(:project) }
    Project.stubs(:sphinx_user_visible).returns(stub(:search => [@project]))
    get :search, :format => 'json', :search_term => 'Awesome', :api_key => @user.api_key
    assert_response :success
    assert JSON.parse(@response.body).first["name"] == @project.name
    assert !(JSON.parse(@response.body).first.has_key? "animal_husbandry")
  end

  test "should get search results in xml format" do
    @project = Factory(:project, :community_name => 'Awesome')
    3.times { Factory(:project) }
    Project.stubs(:sphinx_user_visible).returns(stub(:search => [@project]))
    get :search, :format => 'xml', :search_term => 'Awesome', :api_key => @user.api_key
    assert_response :success
    assert Hash.from_xml(@response.body)['projects'].first['name'] == @project.name
    assert !(Hash.from_xml(@response.body)['projects'].first.has_key? "animal_husbandry")
  end

  test "should return a 400 if no search term was supplied" do
    get :search, :format => 'json', :api_key => @user.api_key
    assert_response 400
  end  

end
