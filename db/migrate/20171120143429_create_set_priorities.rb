class CreateSetPriorities < ActiveRecord::Migration
  def change
    create_table :set_priorities do |t|
      t.references :drain
      t.references :priority

      t.timestamps
    end
    add_index :set_priorities, :drain_id
    add_index :set_priorities, :priority_id
  end
end
