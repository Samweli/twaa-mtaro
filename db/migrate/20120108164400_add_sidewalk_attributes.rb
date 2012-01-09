class AddSidewalkAttributes < ActiveRecord::Migration
  def change
    change_table :chicagosidewalks do |t|
      t.integer :lat, :default => nil, :precision => 16, :scale => 14
      t.integer :lon, :default => nil, :precision => 16, :scale => 14
      t.boolean :cleared
      t.boolean :need_help
      t.string :zipcode
      t.index :cleared
      t.integer :num_adopted, :default => 0
    end
  end

end
