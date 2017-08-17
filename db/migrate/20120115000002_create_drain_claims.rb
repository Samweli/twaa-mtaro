class CreateDrainClaims < ActiveRecord::Migration
  def up
    create_table :drain_claims do |t|
      t.timestamps
      t.integer :user_id
      t.integer :gid
      t.boolean :shoveled
      t.string :notes
    end
    
    add_index :drain_claims, :gid
    add_index :drain_claims, :user_id
  end

  def self.down
    if ActiveRecord::Base.connection.table_exists? :drain_claims
      drop_table :drain_claims
    end
   
  end

end
