class CreateStreets < ActiveRecord::Migration
  def up
    create_table :streets do |t|
      t.string :street_name
      t.string :ward_name
      t.string :municipal_name
      t.string :city_name
      t.timestamps
    end
  end

  def down
    drop_table :streets
  end
end
