class AddOtherNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :other_name, :string
  end
end
