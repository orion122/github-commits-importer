Rails.application.routes.draw do
  root 'commits#welcome'
  post '/get_by_api', to: 'commits#get_by_api'
  post '/save_commits', to: 'commits#save_commits'
  delete '/destroy_commits', to: 'commits#destroy_commits'

  resources :owners, only: [:index] do
    resources :repos, only: [:index] do
      resources :author_emails, only: [:index] do
        resources :commits, only: [:index]
      end
    end
  end
end
