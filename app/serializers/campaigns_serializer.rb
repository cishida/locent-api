class CampaignsSerializer < ActiveModel::Serializer
  attributes :kind, :number_of_targets, :name, :message

end