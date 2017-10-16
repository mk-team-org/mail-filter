class CreateUploadedFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :uploaded_files do |t|
      t.boolean :processed, default: false, null: false
      t.string :emails_file

      t.timestamps
    end
  end
end
