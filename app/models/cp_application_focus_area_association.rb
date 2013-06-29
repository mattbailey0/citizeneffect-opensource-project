class CpApplicationFocusAreaAssociation < ActiveRecord::Base
  belongs_to :cp_application
  belongs_to :focus_area
end
