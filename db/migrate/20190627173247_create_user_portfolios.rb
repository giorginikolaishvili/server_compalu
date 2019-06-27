class CreateUserPortfolios < ActiveRecord::Migration[5.2]
  def change
    create_table :user_portfolios do |t|
      t.string :description
      t.date :start_date
      t.date :end_date
      t.string :company_name

    end
    remove_column :users, :portfolio
  end
end
