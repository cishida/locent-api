class ErrorMessage < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :error
  belongs_to :organization


  validates_presence_of :error_id
  validates_presence_of :organization_id
  validates_presence_of :message

  validates_uniqueness_of :error_id, :scope => :feature_id

end
