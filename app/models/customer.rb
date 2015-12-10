class Customer < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :organization

  validates_uniqueness_of :organization_id
end
