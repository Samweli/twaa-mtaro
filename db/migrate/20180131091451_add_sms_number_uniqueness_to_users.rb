class AddSmsNumberUniquenessToUsers < ActiveRecord::Migration
  def change
    change_column :users, :sms_number, :string, unique: true
  end
end
