require 'test_helper'

class Api::V1::MediasControllerTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
    @user.roles.add!(Role.partner_admin)
    @user.reload
    @user.enable_api!
    @project = Factory(:project)
    @album = Factory(:media_album, :project => @project)
    @photo = @album.medias.first
  end

  test "should get index in json format" do
    get :index, :format => 'json', :project_id => @project.id, :api_key => @user.api_key
    assert_response :success
    assert JSON.parse(@response.body).map {|p| p["title"] }.include? @photo.title
    assert !(JSON.parse(@response.body).first.has_key? "updated_at")
  end

  test "should get index in xml format" do
    get :index, :format => 'xml', :project_id => @project.id, :api_key => @user.api_key
    assert_response :success
    assert Hash.from_xml(@response.body)["medias"].map {|p| p["title"] }.include? @photo.title
    assert !(Hash.from_xml(@response.body)['medias'].first.has_key? "updated_at")
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
