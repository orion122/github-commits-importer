class CreateRepos < ActiveRecord::Migration[5.2]
  def change
    create_table :repos do |t|
      t.string :name
      t.references :owner, foreign_key: true

      t.timestamps
    end
  end
end
