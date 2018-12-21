require 'rails_helper'

RSpec.describe CommitsController, type: :controller do
  describe 'POST #import' do
    let(:messages) { ['add categories', 'create admin dashboard', 'make:auth', 'first commit'] }
    let(:owner) { 'orion122' }
    let(:repo) { 'laravel-blog' }
    let(:author_email) { 'yaru@bk.ru' }
    let(:nonexistent_author_email) { 'author@mail.ru' }

    context 'with existing email' do
      before do
        VCR.use_cassette('laravel-blog') do
          post :import, params: {
              owner: owner,
              repo: repo,
              author_email: author_email
          }
        end
      end

      it 'import commits to database' do
        expect(Commit.pluck(:message)).to eq(messages)
      end

      it 'create owner' do
        expect(Owner.last.name).to eq(owner)
      end

      it 'create repo' do
        expect(Repo.last.name).to eq(repo)
      end

      it 'create author email' do
        expect(AuthorEmail.last.email).to eq(author_email)
      end

      it 'flashes a success message' do
        expect(flash[:success]).to eq('Commits imported')
      end
    end

    context 'with nonexistent email' do
      before do
        VCR.use_cassette('nonexistent_email') do
          post :import, params: {
              owner: owner,
              repo: repo,
              author_email: nonexistent_author_email
          }
        end
      end

      it "doesn't import commits to database" do
        expect(Commit.count).to eq(0)
      end

      it "doesn't create owner" do
        expect(Owner.count).to eq(0)
      end

      it "doesn't create repo" do
        expect(Repo.count).to eq(0)
      end

      it "doesn't create author email" do
        expect(AuthorEmail.count).to eq(0)
      end

      it 'flashes a notice message' do
        expect(flash[:notice]).to eq('Commits not found')
      end
    end

    context 'with empty owner and repo' do
      before do
        VCR.use_cassette('empty_fields') do
          post :import, params: {
              owner: '',
              repo: ''
          }
        end
      end

      it "doesn't import commits to database" do
        expect(Commit.count).to eq(0)
      end

      it "doesn't create owner" do
        expect(Owner.count).to eq(0)
      end

      it "doesn't create repo" do
        expect(Repo.count).to eq(0)
      end

      it "doesn't create author email" do
        expect(AuthorEmail.count).to eq(0)
      end

      it 'flashes a notice message' do
        expect(flash[:notice]).to eq('Not found owner/repo')
      end
    end
  end

  describe 'POST #destroy' do
    let(:messages_not_deleted) { ['make:auth', 'first commit'] }
    let(:messages_deleted) { ['add categories', 'create admin dashboard'] }
    let(:owner) { 'orion122' }
    let(:repo) { 'laravel-blog' }
    let(:author_email) { 'yaru@bk.ru' }

    before do
      VCR.use_cassette('with_existing_email') do
        post :import, params: {
            owner: owner,
            repo: repo,
            author_email: author_email
        }
      end

      commit_ids = Commit.where(message: messages_deleted).pluck(:id)

      post :destroy, params: { commit_ids: commit_ids }
    end

    it 'delete the first two commits' do
      expect(Commit.pluck(:message)).to eq(messages_not_deleted)
    end
  end

  describe 'GET #index' do
    let(:owner) { 'orion122' }
    let(:repo) { 'ruby-koans-solutions' }
    let(:author_email) { 'yaru@bk.ru' }

    before do
      VCR.use_cassette('ruby-koans-solutions') do
        post :import, params: {
            owner: owner,
            repo: repo,
            author_email: author_email
        }
      end
    end

    it 'return first 10 commits' do
      owner = Owner.find_by(name: 'orion122')
      repo = Repo.find_by(name: 'ruby-koans-solutions')
      author_email = AuthorEmail.find_by(email: 'yaru@bk.ru')

      get :index, params: { owner_id: owner, repo_id: repo, author_email_id: author_email }
      expect(assigns(:commits)).to eq(Commit.limit(10))
    end

    it 'return last 10 commits' do
      owner = Owner.find_by(name: 'orion122')
      repo = Repo.find_by(name: 'ruby-koans-solutions')
      author_email = AuthorEmail.find_by(email: 'yaru@bk.ru')
      page = 2

      get :index, params: { owner_id: owner, repo_id: repo, author_email_id: author_email, page: page }
      expect(assigns(:commits)).to eq(Commit.limit(10).offset(10))
    end
  end
end