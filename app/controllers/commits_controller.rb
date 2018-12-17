class CommitsController < ApplicationController
  def welcome; end

  def index
    @owner = Owner.find(params[:owner_id])
    @repo = Repo.find(params[:repo_id])
    @author_email = AuthorEmail.find(params[:author_email_id])
    @commits = @repo.author_emails.find(params[:author_email_id]).commits
  end

  def get_by_api
    owner = params[:owner]
    repo = params[:repo]
    author_email = params[:author_email]

    client = Octokit::Client.new()

    unless owner.nil? and repo.nil? and author_email.nil?
      client.list_commits("#{owner}/#{repo}")
      last_response = client.last_response
      messages = []
      messages.concat(messages_from_response(last_response, author_email))

      until last_response.rels[:next].nil?
        last_response = last_response.rels[:next].get
        messages.concat(messages_from_response(last_response, author_email))
      end

      save_commits(owner, repo, author_email, messages) if messages.any?
    end
  end

  def destroy_commits
    Commit.destroy(params[:commit_ids])
  end

  private
  def messages_from_response(last_response, author_email)
    messages = []
    last_response.data.each do |commit|
      messages << commit.commit.message if commit.commit.author.email == author_email
    end
    messages
  end

  def save_commits(owner_name, repo_name, email, messages)
    owner = Owner.where(name: owner_name).first_or_create
    repo = owner.repos.where(name: repo_name).first_or_create
    author_email = repo.author_emails.where(email: email).first_or_create

    commits_old = repo.commits.where(author_email: author_email)

    commits_old.transaction do
      commits_old.destroy_all

      messages.each do |message|
        author_email.commits.create(message: message)
      end
    end
  end
end
