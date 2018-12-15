class CreateAuthorEmailsRepos < ActiveRecord::Migration[5.2]
  def change
    create_table :author_emails_repos do |t|
      t.integer :author_email_id
      t.integer :repo_id
    end
  end
end
