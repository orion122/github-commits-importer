class Repo < ApplicationRecord
  belongs_to :owner
  has_and_belongs_to_many :author_emails
  has_many :commits, through: :author_emails
end
