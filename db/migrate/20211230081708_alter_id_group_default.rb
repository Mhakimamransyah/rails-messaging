class AlterIdGroupDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :chats, :id_group, 0
    change_column_default :chats, :is_read, 0
  end
end
