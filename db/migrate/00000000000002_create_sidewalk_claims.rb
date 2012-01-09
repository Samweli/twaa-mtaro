class CreateSidewalkClaims < ActiveRecord::Migration
  def change
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
end
