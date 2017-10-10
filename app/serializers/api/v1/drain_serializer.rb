class Api::V1::DrainSerializer < Api::V1::BaseSerializer
attributes :gid, :cleared, :need_help, :address, :waterway, :covered, :depth,
           :width, :blockage, :tunnel, :diameter, :ditch, :drain, :name, :bridge,
           :height, :surface, :smoothness, :oneway, :lat, :lng,
           :zipcode, :claims_count

end