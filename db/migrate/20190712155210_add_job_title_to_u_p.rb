class AddJobTitleToUP < ActiveRecord::Migration[5.2]
  def up
    add_column :user_portfolios, :job_title, :string
  end

  def down
    remove_column :user_portfolios, :job_title
  end
end
