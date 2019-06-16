class FillProfiles < ActiveRecord::Migration[5.2]
  def up
    Profile.create!(name: 'student')
    Profile.create!(name: 'admin')
  end

  def down
    Profile.delete_all
  end
end
