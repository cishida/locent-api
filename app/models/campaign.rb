class Campaign < ActiveRecord::Base
  acts_as_paranoid
  has_many  :messages, as: :purpose, dependent: :destroy
  belongs_to :organization

end
