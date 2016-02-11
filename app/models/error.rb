class Error < ActiveRecord::Base
  acts_as_paranoid
  has_many :error_messages, dependent: :destroy

  validates_presence_of :code
  validates_presence_of :description
  validates_presence_of :default_message


  validates_uniqueness_of :code



end
