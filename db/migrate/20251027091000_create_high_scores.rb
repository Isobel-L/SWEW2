class CreateHighScores < ActiveRecord::Migration[8.0]
  def change
    create_table :high_scores do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :game_key, null: false
      t.integer :score,    null: false, default: 0
      t.timestamps
    end
  
    add_index :high_scores, [:user_id, :game_key], unique: true
  end
end
