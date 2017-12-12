class CreateWards < ActiveRecord::Migration
  def change
    create_table :wards do |t|
      t.string :ward_name
      t.references :municipal

      t.timestamps
    end
    add_index :wards, :municipal_id
  end

  def up
    create_table :wards do |t|
      t.string :ward_name
      t.references :municipal

      t.timestamps
    end
    add_index :wards, :municipal_id
  end

  def down
    if ActiveRecord::Base.connection.column_exists?(:wards, :municipal_id)
      remove_column :wards, :municipal_id
    end
  end
end
