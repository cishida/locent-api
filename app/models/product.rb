class Product < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :subscription, -> { if_feature_has_products }
  belongs_to :organization
  validates_uniqueness_of :uid, :scope => :organization
  validates_uniqueness_of :name, :scope => :organization_id

end
