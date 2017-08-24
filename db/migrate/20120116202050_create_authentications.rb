class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.datetime :expires
      t.string :nickname
      t.timestamps
    end
  end

  def self.down
    if ActiveRecord::Base.connection.table_exists? :authentications
      drop_table :authentications 
    end
  end
end
