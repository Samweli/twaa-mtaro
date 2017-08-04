class ChangeDrains < ActiveRecord::Migration
  def up
    change_table :mitaro_dar do |t|
      t.boolean :cleared
      t.boolean :need_help
      t.string  :address
      t.string :zipcode
      t.index :cleared
      t.integer :claims_count, :default => 0
    end
  end

  def down
    remove_column :mitaro_dar, :cleared
    remove_column :mitaro_dar, :need_help
    remove_column :mitaro_dar, :address
    remove_column :mitaro_dar, :zipcode
    remove_column :mitaro_dar, :claims_count
  end
end


