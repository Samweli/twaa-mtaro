class AddWardRefToStreets < ActiveRecord::Migration

  def up
    change_table :streets do |t|
      t.references :ward
    end
    add_index :streets, :ward_id

    if ActiveRecord::Base.connection.column_exists?(:streets, :ward_name)
      remove_column :streets, :ward_name
    end
    if ActiveRecord::Base.connection.column_exists?(:streets, :municipal_name)
      remove_column :streets, :municipal_name
    end
    if ActiveRecord::Base.connection.column_exists?(:streets, :city_name)
      remove_column :streets, :city_name
    end
  end

  def down
    if ActiveRecord::Base.connection.column_exists?(:streets, :ward_id)
      remove_column :streets, :ward_id
    end
  end

end
