class CreateSearchQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :search_queries do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :domain, null: false
      t.string :nip, null: false
      t.string :company
      t.text :emails, array: true, default: []
      t.boolean :catch_all, default: false
      t.boolean :completed, default: false
      t.string :cant_check
      t.text :tested_emails, array: true, default: []

      t.index :nip

      t.timestamps
    end
  end
end
