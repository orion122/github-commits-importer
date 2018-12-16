class AuthorEmailsController < ApplicationController
  def index
    @author_emails = Owner.find(params[:owner_id]).repos.find(params[:repo_id]).author_emails

    @owner = params[:owner_id]
    @repo = params[:repo_id]
  end

  def show
    author_email = AuthorEmail.find(params[:id])
    @commits = author_email.commits
  end
end
