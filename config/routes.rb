Rails.application.routes.draw do
  root 'welcome#welcome'
  post '/import', to: 'commits#import'
  post '/save', to: 'commits#save'
  delete '/destroy', to: 'commits#destroy'

  resources :owners, only: [:index] do
    resources :repos, only: [:index] do
      resources :author_emails, only: [:index] do
        resources :commits, only: [:index]
      end
    end
  end
end
