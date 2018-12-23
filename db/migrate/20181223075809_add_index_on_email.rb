class AddIndexOnEmail < ActiveRecord::Migration[5.2]
  def change
    add_index :author_emails, :email, unique: true
  end
end
