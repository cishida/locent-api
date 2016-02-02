class Campaign < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :organization

end
