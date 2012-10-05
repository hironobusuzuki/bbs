class DelIndexToNo < ActiveRecord::Migration
  def change
    remove_index :messages, :no
  end
end
