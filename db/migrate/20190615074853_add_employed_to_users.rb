class AddEmployedToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :employed, :boolean, null: false, default: false
    add_column :users, :full_name, :string, null: false, default: ''
    add_column :users, :image_base64, :string
  end

  def down
    remove_column :users, :employed
    remove_column :users, :full_name
    remove_column :users, :image_base64
  end
end
