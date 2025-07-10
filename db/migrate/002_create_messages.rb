class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :chat_room, null: false, foreign_key: true
      t.text :content, null: false
      t.string :username, null: false
      t.timestamps
    end
    
    add_index :messages, [:chat_room_id, :created_at]
  end
end
