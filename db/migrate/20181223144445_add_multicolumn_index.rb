class AddMulticolumnIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :author_emails_repos, [ :author_email_id, :repo_id ], unique: true
  end
end
