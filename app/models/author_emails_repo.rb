class AuthorEmailsRepo < ApplicationRecord
  belongs_to :author_email
  belongs_to :repo
  has_many :commits
end
