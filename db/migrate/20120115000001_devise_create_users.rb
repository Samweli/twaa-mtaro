class DeviseCreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.timestamps
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :organization
      t.string :email, :null => false, :default => ""
      t.string :sms_number
      t.boolean :admin, :default => false
      t.integer :claims_count, :default => 0
      t.integer :role, :default => 1
      t.integer :max_claims
      t.integer :street_id
      t.string :encrypted_password, :null => false, :default => ""
    ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

    ## Rememberable
      t.datetime :remember_created_at
    ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end

    add_index :users, :email, :unique => true
    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    drop_table :users
  end

end
