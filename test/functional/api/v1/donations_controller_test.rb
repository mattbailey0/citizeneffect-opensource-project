require 'test_helper'
require 'ruby-debug'

class Api::V1::DonationsControllerTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
    @user.roles.add!(Role.partner_admin)
    @user.reload
    @user.enable_api!
  end

  test "should post to make a general donation in json format" do
    @project = Factory(:project)
    post :create, :format => 'json', :donation => donation_hash, :api_key => @user.api_key
    assert_response :success
    content = JSON.parse(@response.body)
    assert content['message'] == 'Donation Successful'
  end

  test "should post to make a general donation in xml format" do
    @project = Factory(:project)
    post :create, :format => 'xml', :donation => donation_hash, :api_key => @user.api_key
    assert_response :success
    assert_select 'message', :text => 'Donation Successful'
  end
  
  test "should post to make a project donation in json format" do
    @project = Factory(:project)
    post :create, :format => 'json', :project_id => @project.id, :donation => donation_hash, :api_key => @user.api_key
    assert_response :success
    content = JSON.parse(@response.body)
    assert content['message'] == 'Donation Successful'
  end

  test "should post to make a project donation in xml format" do
    @project = Factory(:project)
    post :create, :format => 'xml', :project_id => @project.id, :donation => donation_hash, :api_key => @user.api_key
    assert_response :success
    assert_select 'message', :text => 'Donation Successful'
  end
  
   test "should return a 400 when passing incomplete donation data" do
    @project = Factory(:project)
    post :create, :format => 'xml', :project_id => @project.id, :donation => donation_hash.merge({:country => nil}), :api_key => @user.api_key
    assert_response 400
    assert_select 'error', :text => "Country can't be blank"
  end  
  
  def donation_hash
    {
      :amount_in_cents => 10000,
      :first_name => "First Name",
      :last_name => "Last Name",
      :address1 => 'Address 1',
      :city => 'Indianapolis',
      :state => 'IN',
      :country => 'United States',
      :zip => '46260',
      :email => 'first@example.com',
      :tip_percentage => 0,
      :agree_tos => "1",
      :public_credit_card_type => "VISA", 
      :credit_card_number => "4242424242424242", 
      :credit_card_cvv => "123", 
      :expiration_year => 2012, 
      :expiration_month => 8
    }
    
  end

end
