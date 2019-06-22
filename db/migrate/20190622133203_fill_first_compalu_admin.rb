class FillFirstCompaluAdmin < ActiveRecord::Migration[5.2]
  def up
    User.delete_all
    profile_id = Profile.find_by(name: 'admin').id
    User.create(username: 'Gigi25', name: 'Giorgi', last_name: 'Nikolaishvili',
                email: 'giorgi.nikolaishvili25@gmail.com', profile_id: profile_id,
                password: 'gigi25')
  end

  def down
    User.delete_all
  end
end
