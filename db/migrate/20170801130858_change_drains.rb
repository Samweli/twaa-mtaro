class ChangeDrains < ActiveRecord::Migration
  def up
    if ENV['RAILS_ENV'] == 'test'
      create_drain_table()
    end

    change_table :mitaro_dar do |t|
      t.boolean :cleared
      t.boolean :need_help
      t.string  :address
      t.string :zipcode
      t.index :cleared
      t.integer :claims_count, :default => 0
    end
    change_column :mitaro_dar, :the_geom, 'geometry USING the_geom::geometry'
  end

  def down
    if ActiveRecord::Base.connection.column_exists?(:mitaro_dar, :cleared)
      remove_column :mitaro_dar, :cleared
    end
    if ActiveRecord::Base.connection.column_exists?(:mitaro_dar, :need_help)
      remove_column :mitaro_dar, :need_help
    end
    if ActiveRecord::Base.connection.column_exists?(:mitaro_dar, :address)
      remove_column :mitaro_dar, :address
    end
    if ActiveRecord::Base.connection.column_exists?(:mitaro_dar, :zipcode)
      remove_column :mitaro_dar, :zipcode
    end
    if ActiveRecord::Base.connection.column_exists?(:mitaro_dar, :claims_count)
      remove_column :mitaro_dar, :claims_count
    end
  end

  def create_drain_table
    create_table "mitaro_dar", :id => false, :force => true do |t|
      t.integer "gid",                                                                        :null => false
      t.string  "the_geom",     :geometry
      t.string  "full_id",      :limit => 254
      t.string  "waterway",     :limit => 254
      t.string  "covered",      :limit => 254
      t.string  "depth",        :limit => 254
      t.string  "width",        :limit => 254
      t.string  "blockage",     :limit => 254
      t.string  "tunnel",       :limit => 254
      t.string  "diameter",     :limit => 254
      t.string  "ditch",        :limit => 254
      t.string  "drain",        :limit => 254
      t.string  "name",         :limit => 254
      t.string  "bridge",       :limit => 254
      t.string  "height",       :limit => 254
      t.string  "surface",      :limit => 254
      t.string  "smoothness",   :limit => 254
      t.string  "oneway",       :limit => 254
      t.decimal "lat",                         :precision => 16, :scale => 14
      t.decimal "lng",                         :precision => 16, :scale => 14
    end
  end
end


