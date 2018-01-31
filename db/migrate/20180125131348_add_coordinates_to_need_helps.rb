class AddCoordinatesToNeedHelps < ActiveRecord::Migration
  def change
    change_table :need_helps do |t|
      t.decimal :lat, :default => nil, :precision => 16, :scale => 14
      t.decimal :long, :default => nil, :precision => 16, :scale => 14
    end

  end
end
