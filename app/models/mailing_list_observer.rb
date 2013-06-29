class MailingListObserver < ActiveRecord::Observer
  observe :donation
  
  def after_create(object)
    if object.mailing_list?
      MailingList.create(:email      => object.email,
                         :zip        => object.zip,
                         :project_id => object.project_id,
                         :user_id    => object.donor_id)
    end        
  end
end
