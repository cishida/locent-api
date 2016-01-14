class Order < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :opt_in

end
