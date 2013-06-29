require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users

  def test_should_create_user
    assert_difference 'User.count' do
      user = Factory.create(:user)
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_initialize_activation_code_upon_creation
    user = Factory.build(:unactivated_user)
    user.register!
    user.reload
    assert_not_nil user.activation_code
  end

  def test_should_create_and_start_in_pending_state
    user = Factory.create(:unactivated_user)
    user.register!
    user.reload
    assert user.pending?
  end


  def test_should_require_email
    assert_no_difference 'User.count' do
      u = Factory.build(:user, :email => nil)
      u.save
      assert u.errors.on(:email)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    (q = Factory.create(:quentin)).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal q, User.authenticate(q.email, 'new password')
  end

  def test_should_not_rehash_password
    (q = Factory.create(:quentin)).update_attributes(:email => 'quentin2@example.com')
    assert_equal q, User.authenticate('quentin2@example.com', 'monkey')
  end

  def test_should_authenticate_user
    q = Factory.create(:quentin)
    assert_equal q, User.authenticate(q.email, 'monkey')
  end

  def test_should_set_remember_token
    (q = Factory.create(:quentin)).remember_me
    assert_not_nil q.reload.remember_token
    assert_not_nil q.remember_token_expires_at
  end

  def test_should_unset_remember_token
    (q = Factory.create(:quentin)).remember_me
    assert_not_nil q.remember_token
    q.forget_me
    assert_nil q.remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    (q = Factory.create(:quentin)).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil q.remember_token
    assert_not_nil q.remember_token_expires_at
    assert q.remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    (q = Factory.create(:quentin)).remember_me_until time
    assert_not_nil q.remember_token
    assert_not_nil q.remember_token_expires_at
    assert_equal q.remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    (q = Factory.create(:quentin)).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil q.remember_token
    assert_not_nil q.remember_token_expires_at
    assert q.remember_token_expires_at.between?(before, after)
  end

  def test_should_register_passive_user
    user = Factory.build(:unactivated_user, :password => nil, :password_confirmation => nil)
    user.save
    assert user.passive?
    user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    user.register!
    assert user.pending?
  end

  def test_should_suspend_user
    (q = Factory.create(:quentin)).suspend!
    assert q.suspended?
  end

  def test_suspended_user_should_not_authenticate
    (q = Factory.create(:quentin)).suspend!
    assert_not_equal q, User.authenticate('quentin', 'test')
  end

  def test_should_unsuspend_user_to_active_state
    (q = Factory.create(:quentin)).suspend!
    assert q.suspended?
    q.unsuspend!
    assert q.active?
  end

  def test_should_unsuspend_user_with_nil_activation_code_and_activated_at_to_passive_state
    (q = Factory.create(:quentin)).suspend!
    User.update_all :activation_code => nil, :activated_at => nil
    assert q.suspended?
    q.reload.unsuspend!
    assert q.passive?
  end

  def test_should_unsuspend_user_with_activation_code_and_nil_activated_at_to_pending_state
    (q = Factory.create(:quentin)).suspend!
    User.update_all :activation_code => 'foo-bar', :activated_at => nil
    assert q.suspended?
    q.reload.unsuspend!
    assert q.pending?
  end

  def test_should_delete_user
    assert_nil (q = Factory.create(:quentin)).deleted_at
    q.delete!
    assert_not_nil q.deleted_at
    assert q.deleted?
  end

  def test_should_generate_an_api_key
    user = Factory(:quentin)
    user.roles.add!(Role.partner_admin)
    user.reload
    user.expects(:generate_api_key!)
    user.enable_api!
  end

  def test_should_remove_the_api_key
    user = Factory(:quentin)
    user.roles.add!(Role.partner_admin)
    user.reload
    user.enable_api!
    assert user.api_key.present?
    user.disable_api!
    assert user.api_key.blank?
  end

  def test_should_tell_us_whether_the_api_key_is_empty
    user = Factory(:quentin)
    user.roles.add!(Role.partner_admin)
    user.reload
    user.enable_api!
    assert user.api_is_enabled?
    user.disable_api!
    assert !user.api_is_enabled?
  end

protected
  def create_user(options = {})
    record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.register! if record.valid?
    record
  end
end
