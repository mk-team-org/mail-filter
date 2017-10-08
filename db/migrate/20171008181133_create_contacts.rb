class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :email,     unique: true, null: false
      t.boolean :excluded, default: false, null: false
      t.boolean :angry,    default: false, null: false

      t.timestamps
    end
  end
end
