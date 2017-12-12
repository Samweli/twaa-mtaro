class CreateWards < ActiveRecord::Migration

  def up
    create_table :wards do |t|
      t.string :ward_name
      t.references :municipal
      t.decimal :lat, :default => nil, :precision => 16, :scale => 14
      t.decimal :lng, :default => nil, :precision => 16, :scale => 14

      t.timestamps
    end
    add_index :wards, :municipal_id
  end

  def down
    if ActiveRecord::Base.connection.table_exists? :wards
      drop_table :wards
    end
  end
end
