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
    end
  end

  describe 'POST #destroy' do
    let(:messages) { ['make:auth', 'first commit'] }
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
      post :destroy, params: { commit_ids: [1, 2] }
    end

    it 'delete the first two commits' do
      expect(Commit.pluck(:message)).to eq(messages)
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
      get :index, params: { owner_id: 1, repo_id: 1, author_email_id: 1 }
      expect(assigns(:commits)).to eq(Commit.limit(10))
    end

    it 'return last 10 commits' do
      get :index, params: { owner_id: 1, repo_id: 1, author_email_id: 1, page: 2 }
      expect(assigns(:commits)).to eq(Commit.limit(10).offset(10))
    end
  end
end