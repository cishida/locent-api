class Subscription < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :organization
  belongs_to :product
  belongs_to :options, polymorphic: :true

  validates_presence_of :organization_id, :product_id
  validates_uniqueness_of :organization_id, :scope => :product_id
end
