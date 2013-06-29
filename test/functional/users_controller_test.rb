require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should generate a new api key if user can access api" do
    @user = Factory(:user)
    @user.roles.add!(Role.partner_admin)
    @user.reload
    put :generate_api_key, :id => @user.id
    assert_redirected_to :action => :edit
    assert_equal "API key generated!", flash[:notice]
  end
  
  test "should not generate a new api key if user does not have api access privileges" do
    @user = Factory(:user)
    put :generate_api_key, :id => @user.id
    assert_redirected_to :action => :edit
    assert_equal "Unable to generate API key", flash[:error]
  end

end
