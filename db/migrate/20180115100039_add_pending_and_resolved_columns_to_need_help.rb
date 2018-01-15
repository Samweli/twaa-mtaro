class AddPendingAndResolvedColumnsToNeedHelp < ActiveRecord::Migration
  def up
    change_table :need_helps do |t|
      t.datetime :pending
      t.datetime :resolved
    end
  end

  def down
    if ActiveRecord::Base.connection.column_exists?(:need_helps, :pending)
      remove_column :need_helps, :pending
    end

    if ActiveRecord::Base.connection.column_exists?(:need_helps, :resolved)
      remove_column :need_helps, :resolved
    end

  end
end
