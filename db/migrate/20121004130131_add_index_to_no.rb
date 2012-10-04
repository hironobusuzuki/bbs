class AddIndexToNo < ActiveRecord::Migration
  def change
    add_index :messages, :no, :unique=>true
  end
end
