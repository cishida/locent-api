class KeywordOptions < ActiveRecord::Base
  acts_as_paranoid

  has_one  :subscription, as: :option, dependent: :destroy
end
