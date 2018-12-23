class Repo < ApplicationRecord
  belongs_to :owner
  has_many :author_emails_repos
  has_many :author_emails, through: :author_emails_repos
end
