class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cat, null: false, foreign_key: true
      t.string :title, null: false
      t.text :text, null: false
      t.string :media_url, null: false
      t.string :media_type, null: false
      t.text :description
      t.string :sharedWith, null: false

      t.timestamps
    end
  end
end
