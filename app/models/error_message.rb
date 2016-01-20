class ErrorMessage < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :error
  belongs_to :organization

  validates_uniqueness_of :error_id, :scope => :feature_id

end
