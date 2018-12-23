class ChangeReferencesForCommits < ActiveRecord::Migration[5.2]
  def change
    remove_reference :commits, :author_email, index: true, foreign_key: true
    add_reference :commits, :author_emails_repo, index: true, foreign_key: true
  end
end
