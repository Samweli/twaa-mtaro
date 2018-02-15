class Api::V1::NeedHelpSerializer < Api::V1::BaseSerializer
  attributes :id, :help_needed, :gid, :user_id
end