class Customer < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :organization
  belongs_to :subscription

  has_many :opt_ins, dependent: :destroy

  validates_uniqueness_of :organization_id, :scope => :phone
end
