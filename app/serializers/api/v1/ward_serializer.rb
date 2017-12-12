class WardSerializer < ActiveModel::Serializer
  attributes :id, :ward_name
  has_one :municipal
end
