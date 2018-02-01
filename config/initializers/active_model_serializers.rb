ActiveModel::Serializer.setup do |config|
  config.embed = :ids
  config.default_includes = '**'
end