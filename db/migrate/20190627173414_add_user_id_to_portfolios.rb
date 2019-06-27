class AddUserIdToPortfolios < ActiveRecord::Migration[5.2]
  def change
    add_column :user_portfolios, :user_id, :bigint, null: false
    add_foreign_key :user_portfolios, :users
  end
end
