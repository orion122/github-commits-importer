class CommitsController < ApplicationController
  def index
    @owner = Owner.find(params[:owner_id])
    @repo = Repo.find(params[:repo_id])
    @author_email = AuthorEmail.find(params[:author_email_id])
    @commits = @repo.author_emails.find(params[:author_email_id]).commits.page(params[:page]).per(10)
  end

  def import
    owner = params[:owner]
    repo = params[:repo]
    author_email = params[:author_email]

    begin
      github = Github.new(auto_pagination: true)
      commits_data = github.repos.commits.all(owner, repo)

      messages = commits_data.map do |commit_data|
        { message: commit_data.commit.message } if commit_data.commit.author.email == author_email
      end

      unless messages.any?
        flash[:notice] = 'Commits not found'
        redirect_back(fallback_location: root_path) and return
      end

      if save?(owner, repo, author_email, messages)
        flash[:success] = 'Commits imported'
      else
        flash[:notice] = 'Commits doesn\'t imported'
      end

    rescue Github::Error::NotFound
      flash[:notice] = 'Not found owner/repo'
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    Commit.destroy(params[:commit_ids])
  end

  private
  def save?(owner_name, repo_name, email, messages)
    owner = Owner.where(name: owner_name).first_or_create
    repo = owner.repos.where(name: repo_name).first_or_create
    author_email = repo.author_emails.where(email: email).first_or_create
    commits_old = repo.commits.where(author_email: author_email)

    begin
      commits_old.transaction do
        commits_old.destroy_all
        author_email.commits.create(messages)
        return true
      end
    rescue ActiveRecord::StatementInvalid
      return false
    end
  end
end
