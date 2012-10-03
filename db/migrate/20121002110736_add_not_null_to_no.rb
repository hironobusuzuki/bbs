class AddNotNullToNo < ActiveRecord::Migration
  def change
    change_column_null :messages, :no, false
  end
end
