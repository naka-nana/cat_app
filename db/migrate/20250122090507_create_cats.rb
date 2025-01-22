class CreateCats < ActiveRecord::Migration[7.1]
  def change
    create_table :cats do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :age_id, null: false
      t.string :breed_id, null: false

      t.timestamps
    end
  end
end
