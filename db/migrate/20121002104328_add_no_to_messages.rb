class AddNoToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :no, :integer
  end
end
