class NeedHelp < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :gid, :help_needed, :user_id, :need_help_category_id, :status,
                  :pending, :resolved, :pending_description,
                  :resolved_description, :lat, :long
  validates_presence_of :gid, :user_id, :need_help_category_id
  belongs_to :drain, :class_name => 'Drain', :foreign_key => "gid"
  belongs_to :user
  belongs_to :need_help_category

  def self.status(need_help_id, status, description)
    need_help = NeedHelp.find(need_help_id)
    need_help.update_attributes(:status => status)
    updatated_at = NeedHelp.find(need_help_id).updated_at
    if (status == "pending")
      need_help.update_attributes(:pending => updatated_at, :pending_description => description)

    elsif (status == "resolved")
      need_help.update_attributes(:resolved => updatated_at, :resolved_description => description)
    end
  end
end
