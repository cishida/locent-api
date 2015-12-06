class Organisation < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_one  :primary_user, -> { where(is_primary: true) }, :class_name => "User"

  validates_presence_of :organisation_name
  validates_uniqueness_of :organisation_name


end
