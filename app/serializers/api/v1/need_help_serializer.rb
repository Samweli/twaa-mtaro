class NeedHelpSerializer < ActiveModel::Serializer
  attributes :id, :help_needed, :gid, :user_id
end