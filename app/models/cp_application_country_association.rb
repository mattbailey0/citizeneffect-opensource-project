class CpApplicationCountryAssociation < ActiveRecord::Base
  belongs_to :cp_application
  belongs_to :country
end
