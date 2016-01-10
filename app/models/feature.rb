class Feature < ActiveRecord::Base
  acts_as_paranoid

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :organizations, through: :subscriptions
  has_many :subscriptions, dependent: :destroy
  has_many :opt_ins, dependent: :destroy
end