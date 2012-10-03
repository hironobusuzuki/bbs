class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :name ,:null=>false
      t.string :email ,:null=>false
      t.string :sub ,:null=>false
      t.string :comment ,:null=>false
      t.string :host ,:null=>false
      t.string :pwd ,:null=>false
      t.boolean :delflg ,:null=>false

      t.timestamps
    end
  end
end
