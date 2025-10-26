class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string, null: false
    add_column :users, :school, :string
    add_column :users, :password_digest, :string, null: false
    add_column :users, :alien_points, :integer, default: 0, null: false
    add_column :users, :blastoff_points, :integer, default: 0, null: false

    add_index :users, :username, unique: true
  end
end
