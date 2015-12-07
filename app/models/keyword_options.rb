class KeywordOptions < ParanoidModel
  acts_as_paranoid

  has_one  :subscription, as: :option, dependent: :destroy
end
