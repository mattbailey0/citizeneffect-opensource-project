module ApprovalStatusesHelper

  def has_approval_status?
    !self.approval.blank?
  end

  def approval_status
    self.approval.andand.status || "Pending"
  end

  def next_step
    self.approval.andand.next_step
  end

end
