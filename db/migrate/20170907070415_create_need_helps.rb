class CreateNeedHelps < ActiveRecord::Migration
  def change
    create_table :need_helps do |t|
      t.string :help_needed
      t.integer :gid
      t.integer :user_id

      t.timestamps
    end
  end
end
