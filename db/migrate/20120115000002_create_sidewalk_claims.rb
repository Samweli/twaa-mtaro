class CreateSidewalkClaims < ActiveRecord::Migration
  def up
    create_table :sidewalk_claims do |t|
      t.timestamps
      t.integer :user_id
      t.integer :gid
      t.boolean :shoveled
      t.string :notes
    end
    
    add_index :sidewalk_claims, :gid
    add_index :sidewalk_claims, :user_id
  end
  change_table :mitaro_dar do |t|
      t.decimal :lat, :default => nil, :precision => 16, :scale => 14
      t.decimal :lng, :default => nil, :precision => 16, :scale => 14
      t.boolean :cleared
      t.boolean :need_help
      t.string :zipcode
      t.inde :cleared
      t.integer :claims_count, :default => 0
    end

  def self.down
    drop_table :sidewalk_claims
  end

end
