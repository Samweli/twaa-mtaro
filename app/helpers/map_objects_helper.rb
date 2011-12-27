module MapObjectsHelper
  def get_safe_id(map_object)
    map_object.try(:id)
  end
  
end
