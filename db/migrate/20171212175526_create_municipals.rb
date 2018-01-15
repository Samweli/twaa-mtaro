class CreateMunicipals < ActiveRecord::Migration

  def up
    create_table :municipals do |t|
      t.string :municipal_name
      t.string :city_name
      t.decimal :lat, :default => nil, :precision => 16, :scale => 14
      t.decimal :lng, :default => nil, :precision => 16, :scale => 14

      t.timestamps
    end
  end

  def down
    if ActiveRecord::Base.connection.table_exists? :municipals
      drop_table :municipals
    end
  end


end
