class AuthorEmailsController < ApplicationController
  def index
    @owner = Owner.find(params[:owner_id])
    @repo = Repo.find(params[:repo_id])
    @author_emails = @repo.author_emails
  end
end
