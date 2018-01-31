class AddDefaultyStatusToNeedHelps < ActiveRecord::Migration
  def up
    change_column :need_helps, :status, :string, :default => 'submitted'
  end

  def down

  end
end