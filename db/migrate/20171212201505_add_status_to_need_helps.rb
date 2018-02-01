class AddStatusToNeedHelps < ActiveRecord::Migration
  def change
  	change_table :need_help do |t|
  		t.string :need_helps
  	end
  end
end
