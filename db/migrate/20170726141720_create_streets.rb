class CreateStreets < ActiveRecord::Migration
  def up
    create_table :streets do |t|
      t.string :street_name
      t.string :ward_name
      t.string :municipal_name
      t.string :city_name
      t.timestamps
     
    end
    change_table :streets do |t|
      t.decimal :lat, :default => nil, :precision => 16, :scale => 14
      t.decimal :lng, :default => nil, :precision => 16, :scale => 14
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists? :streets
      drop_table :streets
    end
  end
end
