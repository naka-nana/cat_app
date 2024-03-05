class AddNamesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_name, :string, null: false unless column_exists?(:users, :last_name)
    add_column :users, :first_name, :string, null: false unless column_exists?(:users, :first_name)
    add_column :users, :last_name_kana, :string, null: false unless column_exists?(:users, :last_name_kana)
    add_column :users, :first_name_kana, :string, null: false unless column_exists?(:users, :first_name_kana)
    add_column :users, :birth_date, :date, null: true unless column_exists?(:users, :birth_date)
    add_column :users, :prefecture_id, :integer, null: false
  end
end
