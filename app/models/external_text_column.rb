class ExternalTextColumn < ActiveRecord::Base
  belongs_to :column_owner, :polymorphic => true
end
