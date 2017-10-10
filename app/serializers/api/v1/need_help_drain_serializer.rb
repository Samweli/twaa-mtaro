class Api::V1::NeedHelpDrainSerializer < Api::V1::BaseSerializer
  attributes :gid, :user_id, :help_needed, :category_name, :cleared, :need_help, :address, :waterway, :covered, :depth,
             :width, :blockage, :tunnel, :diameter, :ditch, :drain, :name, :bridge,
             :height, :surface, :smoothness, :oneway, :lat, :lng,
             :zipcode, :claims_count
end