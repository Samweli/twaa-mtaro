class CreateDrainsStreets < ActiveRecord::Migration
  def change
    create_table :drains_streets do |t|
      t.integer :drain_id
      t.integer :street_id
    end
  end
  def self.down
    if ActiveRecord::Base.connection.table_exists? :drains_streets
      drop_table :drains_streets
    end
  end
end
