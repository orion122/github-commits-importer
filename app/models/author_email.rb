class AuthorEmail < ApplicationRecord
  has_many :author_emails_repos
  has_many :repos, through: :author_emails_repos
end
