class AddRememberTokenToUsers < ActiveRecord::Migration

  def change
    add_column :users, :remember_token, :string
    #we retrieve users by remember token so we index them
    add_index  :users, :remember_token
  end
end