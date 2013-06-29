class CpApplicationLivesImpactedRangeAssociation < ActiveRecord::Base
  belongs_to :cp_application
  belongs_to :lives_impacted_range
end
