class Subscription < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :organization
  belongs_to :feature
  belongs_to :options, polymorphic: :true, dependent: :destroy
  has_many :opt_ins, dependent: :destroy
  has_many :customers, through: :opt_ins, dependent: :destroy


  validates_presence_of :organization_id, :feature_id
  validates_uniqueness_of :organization_id, :scope => :feature_id
end
