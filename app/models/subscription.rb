class Subscription < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :organisation
  belongs_to :product
  belongs_to :option, polymorphic: :true

  validates_presence_of :organisation_id, :product_id
  validates_uniqueness_of :organisation_id, :scope => :product_id
end
