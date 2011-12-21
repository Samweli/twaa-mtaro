class CreateMapObject < ActiveRecord::Migration
  def change
    create_table :mapobjects do |t|
      t.timestamps
      t.string :name
      t.decimal :lat, :null => false, :precision => 16, :scale => 14
      t.decimal :lng, :null => false, :precision => 17, :scale => 14
      t.integer :source_id
      t.integer :source_type
      t.integer :object_type
      t.integer :gid
      t.integer :status
    end

    add_index :mapobjects, :gid
    add_index :mapobjects, :source_id
  end
end
