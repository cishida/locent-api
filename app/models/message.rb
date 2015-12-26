class Message < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :purpose, polymorphic: :true, dependent: :destroy
end
