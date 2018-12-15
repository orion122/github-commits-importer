class CreateAuthorEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :author_emails do |t|
      t.string :email

      t.timestamps
    end
  end
end
