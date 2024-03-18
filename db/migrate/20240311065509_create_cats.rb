class CreateCats < ActiveRecord::Migration[7.0]
  def change
    create_table :cats do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :age_id, null: false
      t.date :birthday, null: false
      t.integer :breed_id, null: false
      t.integer :color_id, null: false
      t.timestamps
    end
  end
end
