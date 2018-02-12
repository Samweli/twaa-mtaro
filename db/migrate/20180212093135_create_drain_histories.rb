class CreateDrainHistories < ActiveRecord::Migration
  def up
    create_table :drain_histories do |t|
      t.timestamps
      t.integer :gid
      t.integer :user_id
      t.integer :drain_claim_id
      t.integer :street_id
      t.integer :priority_id
      t.string  :action
      t.boolean :cleared
      t.boolean :need_help
    end

    add_index :drain_histories, :gid
    add_index :drain_histories, :user_id
    add_index :drain_histories, :drain_claim_id
    add_index :drain_histories, :street_id
    add_index :drain_histories, :priority_id

  end

  def down
    if ActiveRecord::Base.connection.table_exists? :drain_histories
      drop_table :drain_histories
    end
  end
end
