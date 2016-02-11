# @restful_api 1.0
#
# @property [Error] error The error it belongs to
# @property [String] message
#
#
class ErrorMessage < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :error
  belongs_to :organization


  validates_presence_of :error_id
  validates_presence_of :organization_id
  validates_presence_of :message

  validates_uniqueness_of :error_id, :scope => :organization_id

end
