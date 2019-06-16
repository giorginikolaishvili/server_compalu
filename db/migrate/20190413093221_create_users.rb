class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, limit: 50, null:false
      t.string :name, limit: 50, null: false
      t.string :last_name, limit: 50, null: false
      t.string :email, limit: 100, null: false
      t.date :birth_date
      t.date :apply_date
      t.date :graduate_date
      t.bigint :profile_id, null: false

      t.timestamps
    end
  end
end