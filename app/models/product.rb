class Product < ActiveRecord::Base
  belongs_to :subscription, -> { if_feature_has_products }
  belongs_to :organization


  scope :if_subscription_feature_has_products, -> {where(subscription: {feature: {has_products: true}})}
end
