class Message < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :purpose, polymorphic: :true, dependent: :destroy


  def purpose_feature
    if self.purpose.is_a? Order
      return self.purpose.feature
    elsif self.purpose.is_a? OptIn
      return self.purpose.feature.name
    end
  end
end
