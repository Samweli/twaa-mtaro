class AddDefaultyStatusToNeedHelps < ActiveRecord::Migration
  def up
    change_column :need_helps, :status, :string, :default => 'umewasilishwa'
  end

  def down

  end
end
