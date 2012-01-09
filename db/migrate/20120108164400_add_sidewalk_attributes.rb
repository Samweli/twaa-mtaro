class AddSidewalkAttributes < ActiveRecord::Migration
  def change
    change_table :chicagosidewalks do |t|
      t.decimal :lat, :default => nil, :precision => 16, :scale => 14
      t.decimal :lon, :default => nil, :precision => 16, :scale => 14
      t.boolean :cleared
      t.boolean :need_help
      t.string :zipcode
      t.index :cleared
      t.integer :claims_count, :default => 0
    end
  end

end
