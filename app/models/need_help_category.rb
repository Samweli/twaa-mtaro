class NeedHelpCategory < ActiveRecord::Base
  attr_accessible :category_name
  has_many :need_helps
end
