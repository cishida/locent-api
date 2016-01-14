class Order < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :opt_in
  belongs_to :organization
  validates_uniqueness_of :organization_id, :scope => :uid


end
