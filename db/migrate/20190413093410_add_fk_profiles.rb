class AddFkProfiles < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :profile_id, :bigint
    add_foreign_key :users, :profiles, column: :profile_id
    add_index :users, :profile_id
  end

  def down
    remove_foreign_key :users, :profiles, column: :profile_id
    remove_index :users, :profile_id
  end
end
