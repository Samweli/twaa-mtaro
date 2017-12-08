class Api::V1::DrainSerializer < Api::V1::BaseSerializer
attributes :gid, :cleared, :need_help, :address, :waterway, :covered, :depth,
           :width, :blockage, :tunnel, :diameter, :ditch, :drain, :name, :bridge,
           :height, :surface, :smoothness, :oneway, :lat, :lng,
           :zipcode, :claims_count


  has_many :streets, embed: :objects
  has_many :priorities, through: :set_priorities, embed: :objects

end