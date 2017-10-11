class ChangeDrains < ActiveRecord::Migration
  def up
    # change_table :mitaro_dar do |t|
    #   t.boolean :cleared
    #   t.boolean :need_help
    #   t.string  :address
    #   t.string :zipcode
    #   t.index :cleared
    #   t.integer :claims_count, :default => 0
    # end
  end

  def down
    if ActiveRecord::Base.connection.column_exists?(:mitaro_dar, :cleared)
      remove_column :mitaro_dar, :cleared
    end
    if ActiveRecord::Base.connection.column_exists?(:mitaro_dar, :need_help)
      remove_column :mitaro_dar, :need_help
    end
    if ActiveRecord::Base.connection.column_exists?(:mitaro_dar, :address)
      remove_column :mitaro_dar, :address
    end
    if ActiveRecord::Base.connection.column_exists?(:mitaro_dar, :zipcode)
      remove_column :mitaro_dar, :zipcode
    end
    if ActiveRecord::Base.connection.column_exists?(:mitaro_dar, :claims_count)
      remove_column :mitaro_dar, :claims_count
    end
  end
end


