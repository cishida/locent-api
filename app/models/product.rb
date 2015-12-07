class Product < ActiveRecord::Base
  acts_as_paranoid

  validates_presence_of :name

  has_many :subscriptions, dependent: :destroy
  has_many :organisations, through: :subscriptions, dependent: :destroy
end
