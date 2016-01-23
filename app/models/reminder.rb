class Reminder < ActiveRecord::Base
  belongs_to :order
  after_create :set_initial_last_sent



  def set_initial_last_sent
    self.update(last_sent: self.created_at)
  end

end
