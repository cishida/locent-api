class Customer < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :organization
  belongs_to :opt_in, dependent: :destroy
  belongs_to :subscription


  validates_uniqueness_of :organization_id, :scope => :phone
end
