class AddStatusDescriptionsToNeedHelps < ActiveRecord::Migration
  def up
    change_table :need_helps do |t|
      t.string :pending_description
      t.string :resolved_description
    end
    change_column :need_helps, :status, :string, :default => 'submitted'
  end

  def down
    if ActiveRecord::Base.connection.column_exists?(:need_helps, :pending)
      remove_column :need_helps, :pending_description
    end

    if ActiveRecord::Base.connection.column_exists?(:need_helps, :resolved)
      remove_column :need_helps, :resolved_description
    end

  end
end
