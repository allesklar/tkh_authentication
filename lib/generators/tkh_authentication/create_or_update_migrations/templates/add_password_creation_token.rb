class AddPasswordCreationToken < ActiveRecord::Migration
  def change
    add_column :users, :password_creation_token, :string
    add_column :users, :password_creation_token_sent_at, :datetime
  end
end
