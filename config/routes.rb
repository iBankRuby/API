Rails.application.routes.draw do
  resources :accounts, except: %i[edit] do
    resources :transactions, only: %i[create update]
    resources :invites, only: %i[index create destroy update]
    resources :management
    resources :co_users
    resources :rules, except: %i[show destroy]
    resources :exceeding_requests, only: %i[create destroy]
  end
  #devise_scope :user do
	#  get '/home', to: 'devise/home#new'
  #end
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :limits

  resources :profile

  root to: 'accounts#index'
end
