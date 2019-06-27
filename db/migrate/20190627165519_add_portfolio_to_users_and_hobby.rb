class AddPortfolioToUsersAndHobby < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :portfolio, :text
    add_column :users, :hobby, :string
  end
end
