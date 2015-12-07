class Organisation < ParanoidModel
  acts_as_paranoid

  has_many :users, dependent: :destroy
  has_one  :primary_user, -> { where(is_primary: true) }, :class_name => "User"

  has_many :subscriptions, dependent: :destroy
  has_many :products, through: :subscriptions, dependent: :destroy

  validates_presence_of :organisation_name
  validates_uniqueness_of :organisation_name


end
