class AddSidewalkAttributes < ActiveRecord::Migration
  def change
    change_table :mitaro_dar do |t|
      t.decimal :lat, :default => nil, :precision => 16, :scale => 14
      t.decimal :lng, :default => nil, :precision => 16, :scale => 14
      t.boolean :cleared
      t.boolean :need_help
      t.string :zipcode
      t.string :user_phone
      t.string :address
      t.index :cleared
      t.integer :claims_count, :default => 0
    end
  end

end
