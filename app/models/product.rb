class Product < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :subscription, -> { if_feature_has_products }
  belongs_to :organization
  validates_uniqueness_of :organization_id, :scope => :uid

  scope :if_subscription_feature_has_products, -> {where(subscription: {feature: {has_products: true}})}
end
