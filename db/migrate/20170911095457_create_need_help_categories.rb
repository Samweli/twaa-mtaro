class CreateNeedHelpCategories < ActiveRecord::Migration
  def change
    create_table :need_help_categories do |t|
      t.string :category_name

      t.timestamps
    end
  end
end
