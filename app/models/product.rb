class Product < ActiveRecord::Base
  belongs_to :subscription, -> { if_feature_has_products }


  scope :if_subscription_feature_has_products, -> {where(subscription: {feature: {has_products: true}})}
end
