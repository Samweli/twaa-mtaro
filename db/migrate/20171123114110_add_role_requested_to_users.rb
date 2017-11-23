class AddRoleRequestedToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.integer :role_requested
    end
    if ActiveRecord::Base.connection.column_exists?(:users, :role)
      remove_column :users, :role
    end
  end

  def down
    if ActiveRecord::Base.connection.column_exists?(:users, :role_requested)
      remove_column :users, :role_requested
    end
  end
end
