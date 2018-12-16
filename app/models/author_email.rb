class AuthorEmail < ApplicationRecord
  has_and_belongs_to_many :repos
  has_many :commits
end
