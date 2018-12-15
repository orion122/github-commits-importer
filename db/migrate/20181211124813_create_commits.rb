class CreateCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :commits do |t|
      t.string :message
      t.references :author_email, foreign_key: true

      t.timestamps
    end
  end
end
