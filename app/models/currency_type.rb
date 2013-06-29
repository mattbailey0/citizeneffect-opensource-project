class CurrencyType < ActiveRecord::Base
  default_scope :order => 'currency_code'
end
