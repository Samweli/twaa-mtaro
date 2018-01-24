class AddPriorityToDrains < ActiveRecord::Migration
  def change
    add_column :mitaro_dar, :priority, :boolean
  end
end
