require 'test_helper'

class Api::V1::MailingListUsersControllerTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
    @user.roles.add!(Role.partner_admin)
    @user.reload
    @user.enable_api!
  end

  test "should post to create a mailing list user in json format" do
    @project = Factory(:project)
    @mailing_list = MailingList.create(:project_id => @project)
    post :create, :format => 'json', :project_id => @project.id, :mailing_list_user => {:email => 'me@example.com', :zip => '46260'}, :api_key => @user.api_key
    assert_response :success
    content = JSON.parse(@response.body)
    assert content['email'] == 'me@example.com'
  end

  test "should post to create a mailing list user in xml format" do
    @project = Factory(:project)
    @mailing_list = MailingList.create(:project_id => @project)
    post :create, :format => 'xml', :project_id => @project.id, :mailing_list_user => {:email => 'me@example.com', :zip => '46260'}, :api_key => @user.api_key
    assert_response :success
    assert_select 'email', :text => 'me@example.com'
  end

  test "should return a 404 if the project id does not exist" do
    post :create, :format => 'json', :project_id => 'omg id', :api_key => @user.api_key
    assert_response 404
  end

  test "should return a 400 if no email was supplied" do
    @project = Factory(:project)
    post :create, :format => 'json', :project_id => @project.id, :api_key => @user.api_key
    assert_response 400
  end

  test "should return a 400 if the project id was not supplied" do
    post :create, :format => 'json', :api_key => @user.api_key
    assert_response 400
  end

end
