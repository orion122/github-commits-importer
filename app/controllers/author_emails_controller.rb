class AuthorEmailsController < ApplicationController
  def index
    @owner = Owner.find(params[:owner_id])
    @repo = Repo.find(params[:repo_id])
    @author_emails = @repo.author_emails
  end

  def show
    author_email = AuthorEmail.find(params[:id])
    @commits = author_email.commits
  end
end
