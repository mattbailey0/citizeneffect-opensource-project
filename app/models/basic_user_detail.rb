class BasicUserDetail < ActiveRecord::Base
  has_one :user, :as => :details
end
