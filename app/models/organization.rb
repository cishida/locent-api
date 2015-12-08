class Organization < ActiveRecord::Base
  acts_as_paranoid

  has_many :users, dependent: :destroy
  has_one  :primary_user, -> { where(is_primary: true) }, :class_name => "User"

  has_many :subscriptions, dependent: :destroy
  has_many :products, through: :subscriptions, dependent: :destroy

  validates_presence_of :organization_name
  validates_uniqueness_of :organization_name


end
