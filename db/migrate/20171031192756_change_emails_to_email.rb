class ChangeEmailsToEmail < ActiveRecord::Migration[5.0]
  def change
    rename_column :search_queries, :emails, :email
  end
end
