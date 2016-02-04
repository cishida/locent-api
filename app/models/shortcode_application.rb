class ShortcodeApplication < ActiveRecord::Base
  belongs_to :organization
  validates_inclusion_of :vanity_or_random, :in => ["vanity", "random"], allow_nil: false
  validates_inclusion_of :payment_frequency, :in => ["$3000/quarter", "$11,000/year"], allow_nil: false
  validates_inclusion_of :status, :in => ["pending", "rejected", "approved"], allow_nil: false

end
