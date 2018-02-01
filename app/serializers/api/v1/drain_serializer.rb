class Api::V1::DrainSerializer < Api::V1::BaseSerializer
attributes :gid, :cleared, :need_help, :address, :waterway, :covered, :depth,
           :width, :blockage, :tunnel, :diameter, :ditch, :drain, :name, :bridge,
           :height, :surface, :smoothness, :oneway, :lat, :lng, :label, :value,
           :zipcode, :claims_count

has_many :streets, embed: :objects
has_many :wards, embed: :objects
has_many :municipals, embed: :objects
has_many :priorities, through: :set_priorities, embed: :objects



def name
  object.gid
end

def label
  object.gid
end
def value
  object.gid
end

end