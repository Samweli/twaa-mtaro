class CreateNeedHelpCategories < ActiveRecord::Migration
  def change
    create_table :need_help_categories do |t|
      t.string :category_name

      t.timestamps
    end
  end
  def self.down
    if ActiveRecord::Base.connection.table_exists? :need_help_categories
      drop_table :need_help_categories
    end
  end
end
