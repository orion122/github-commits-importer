Rails.application.routes.draw do
  root 'owners#new'

  resources :owners, only: [:index, :new, :create, :show, :destroy]

  resources :repos, only: [:index, :create, :show, :destroy] do
    resources :author_emails, only: [:index, :create, :show, :destroy] do
      resources :commits, only: [:index, :create, :update, :destroy]
    end
  end
end
