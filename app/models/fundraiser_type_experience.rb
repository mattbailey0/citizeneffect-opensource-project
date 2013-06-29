class FundraiserTypeExperience < ActiveRecord::Base
  belongs_to :user
  belongs_to :fundraiser_type
  
  validates_presence_of :user
  validates_presence_of :fundraiser_type
  validates_presence_of :quote
  
  def cp_name
    self.user.andand.name
  end
  
end
