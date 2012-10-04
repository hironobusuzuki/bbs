class DelNotNullToNo < ActiveRecord::Migration
  def change
    change_column_null :messages, :no, true
    execute "update messages set no = null where delflg = 't';"
  end
end
