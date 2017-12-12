class CreateMunicipals < ActiveRecord::Migration
  def change
    create_table :municipals do |t|
      t.string :municipal_name
      t.string :city_name

      t.timestamps
    end
  end
end
