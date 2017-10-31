class ChangeEmail < ActiveRecord::Migration[5.0]
  def change
    change_column :search_queries, :email, :string, default: nil
  end
end
