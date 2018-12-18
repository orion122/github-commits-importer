class CommitsController < ApplicationController
  def index
    @owner = Owner.find(params[:owner_id])
    @repo = Repo.find(params[:repo_id])
    @author_email = AuthorEmail.find(params[:author_email_id])
    @commits = @repo.author_emails.find(params[:author_email_id]).commits.page(params[:page]).per(10)
  end

  def import
    if params.has_key?(:owner) && params.has_key?(:repo) && params.has_key?(:author_email)
      owner = params[:owner]
      repo = params[:repo]
      author_email = params[:author_email]
      client = Octokit::Client.new()

      begin
        client.list_commits("#{owner}/#{repo}")
        last_response = client.last_response
        messages = []
        messages.concat(messages_from_response(last_response, author_email))

        until last_response.rels[:next].nil?
          last_response = last_response.rels[:next].get
          messages.concat(messages_from_response(last_response, author_email))
        end

        if messages.any?
          flash[:notice] = save?(owner, repo, author_email, messages) ? 'Commits successfully imported' : "Commits doesn't imported"
        else
          flash[:notice] = 'Commits not found'
        end

      rescue Octokit::NotFound
        flash[:notice] = "#{owner}/#{repo} not found"
      end
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    Commit.destroy(params[:commit_ids])
  end

  private
  def messages_from_response(last_response, author_email)
    messages = []
    last_response.data.each do |commit|
      messages << { message: commit.commit.message } if commit.commit.author.email == author_email
    end
    messages
  end

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
