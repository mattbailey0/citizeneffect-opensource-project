class UserObserver < ActiveRecord::Observer
  def after_create(user)
    unless user.do_not_send_emails
      email = UserSignupNotificationEmail.create(
                                                 :user_id         => user.id,
                                                 :recipients      => [user.email],
                                                 :activation_code => user.activation_code
                                                 )
      email.send_later(:send!)
    end
    
    ImportedContact.find(:all, :conditions => { :email => user.email, :recruited => false }).each do |c|
      c.update_attributes(:user => user)
    end
    
    unless user.referral_code.blank?
      c = ImportedContact.find_by_referral_code(user.referral_code)
      c.update_attributes(:user => user, :recruited => true) unless c.nil?
    end
    
    EventAttendanceResponse.find(:all, :conditions => { :email => user.email }).each do |r|
      r.update_attributes(:user => user)
    end
    
    MailingListUser.find(:all, :conditions => {:email => user.email, :user_id => nil}).each do |m_user|
      unless m_user.update_attributes(:email => nil, :zip => nil, :user => user)
        m_user.destroy #this is now a duplicate
      end
    end
    
    MailingListUser.create(:user => user, :mailing_list => MailingList.global_list)
    
    true
  end
  
  def after_save(user)
    return unless user.recently_activated?

    unless user.do_not_send_emails
      email = UserActivationEmail.create(
                                         :user_id    => user.id,
                                         :recipients => [user.email]
                                         )
      email.send_later(:send!)
    end
  end
end
