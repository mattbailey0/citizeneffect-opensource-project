class Country < ActiveRecord::Base
  named_scope :alphabetical, :order => "name"
end
