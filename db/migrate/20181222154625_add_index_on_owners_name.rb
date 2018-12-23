class AddIndexOnOwnersName < ActiveRecord::Migration[5.2]
  def change
    add_index :owners, :name, unique: true
  end
end
