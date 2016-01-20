class Error < ActiveRecord::Base
  acts_as_paranoid
  validates_uniqueness_of :code


end
