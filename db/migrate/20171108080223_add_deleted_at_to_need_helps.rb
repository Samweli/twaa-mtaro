class AddDeletedAtToNeedHelps < ActiveRecord::Migration
  def change
    add_column :need_helps, :deleted_at, :datetime
    add_index :need_helps, :deleted_at
  end
end
