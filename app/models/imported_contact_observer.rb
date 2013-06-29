class ImportedContactObserver < ActiveRecord::Observer
  def after_save(contact)
    return if(contact.recruited)
    
    u = User.find_by_email(contact.email)
    contact.update_attributes(:user => u) unless u == contact.user
  end
end
