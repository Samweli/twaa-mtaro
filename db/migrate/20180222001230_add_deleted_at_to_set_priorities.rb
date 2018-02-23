class AddDeletedAtToSetPriorities < ActiveRecord::Migration
  def change
    add_column :set_priorities, :deleted_at, :datetime
    add_index :set_priorities, :deleted_at
  end
end
