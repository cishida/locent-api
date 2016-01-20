class Error < ActiveRecord::Base
  acts_as_paranoid
  has_many :error_messages, dependent: :destroy
  belongs_to :organization

  validates_uniqueness_of :code



end
