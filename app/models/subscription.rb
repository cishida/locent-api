class Subscription < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :organization
  belongs_to :feature
  belongs_to :options, polymorphic: :true, dependent: :destroy
  has_many :opt_ins, dependent: :destroy
  has_many :customers, through: :opt_ins, dependent: :destroy
  has_many :products


  validates_presence_of :organization_id, :feature_id
  validates_uniqueness_of :organization_id, :scope => :feature_id

  scope :if_feature_has_products, -> { where(feature: {has_products: true}) }


  def are_options_urls_complete?
    options = self.options
    if (options.opt_in_confirmation_url.blank?) || (options.opt_in_verification_url.blank?) || (options.purchase_request_url.blank?)
      return false
    else
      return true
    end
  end

end
