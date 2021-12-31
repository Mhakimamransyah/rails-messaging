class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.text :messages
      t.integer :id_group
      t.integer :from_user
      t.integer :to_user
      t.integer :replies_id
      t.integer :is_read

      t.timestamps
    end
  end
end
