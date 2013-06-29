class ApprovableAssociation < ActiveRecord::Base
  belongs_to :approvable, :polymorphic => true
  belongs_to :approval
  
  accepts_nested_attributes_for :approval
  after_save :approve_approvable
  
  def approve_approvable
    return unless self.approval && self.approvable

    if(self.approval.approved? && self.approvable.respond_to?(:approve!))
      self.approvable.approve! 
    elsif(self.approval.denied? && self.approvable.respond_to?(:deny!))
      self.approvable.deny! 
    end
  end
end
