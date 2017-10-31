class ChangeEmailsToEmail < ActiveRecord::Migration[5.0]
  def change
    change_column :search_queries, :emails, :string, default: :nil
    rename_column :search_queries, :emails, :email
  end
end
