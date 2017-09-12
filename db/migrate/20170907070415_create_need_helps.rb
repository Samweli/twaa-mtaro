class CreateNeedHelps < ActiveRecord::Migration
  def change
    create_table :need_helps do |t|
      t.string :help_needed
      t.integer :gid
      t.integer :user_id
      t.integer :need_help_category_id

      t.timestamps
    end
  end
  def self.down
    if ActiveRecord::Base.connection.table_exists? :need_helps
      drop_table :need_helps
    end
  end
end
