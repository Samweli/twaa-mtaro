class AddStatusToNeedHelps < ActiveRecord::Migration
  def change
    add_column :need_helps, :status, :string
  end
end
