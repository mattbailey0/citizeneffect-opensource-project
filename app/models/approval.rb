class Approval < ActiveRecord::Base  

  APPROVED_STATUS = "Approved"
  DENIED_STATUS = "Denied"
  NEEDS_MORE_INFORMATION_STATUS = "Needs More Information"
  PENDING_STATUS = "Pending"
  NON_PENDING_STATUSES = [APPROVED_STATUS, DENIED_STATUS, NEEDS_MORE_INFORMATION_STATUS]
  
  def clear_all
    write_attribute "approved_at",   nil
    write_attribute "next_step",     nil
    write_attribute "whats_missing", nil
    write_attribute "sent_back_at",  nil
    write_attribute "denied_reason", nil
    write_attribute "denied_at",     nil
  end
  
  def denied_reason=(value)
    self.clear_all
    write_attribute "denied_at", Time.now
    write_attribute "denied_reason", value
  end
  
  def next_step=(value)
    self.clear_all
    write_attribute "approved_at", Time.now
    write_attribute "next_step", value
  end
  
  def whats_missing=(value)
    self.clear_all
    write_attribute "sent_back_at", Time.now
    write_attribute "whats_missing", value
  end
  
  def approved?
    !self.approved_at.blank?
  end
  
  def denied?
    !self.denied_at.blank?
  end
  
  def needs_more_information?
    !self.sent_back_at.blank?
  end
  
  def pending?
    !self.approved? && !self.denied? && !self.needs_more_information?
  end
  
  def status
    return APPROVED_STATUS if self.approved?
    return DENIED_STATUS if self.denied?
    return NEEDS_MORE_INFORMATION_STATUS if self.needs_more_information?
    PENDING_STATUS
  end
end
