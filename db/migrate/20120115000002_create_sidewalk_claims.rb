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



  def self.down
    if ActiveRecord::Base.connection.table_exists? :sidewalk_claims
      drop_table :sidewalk_claims
    end
  end

end
