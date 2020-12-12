Rails.application.routes.draw do

  root 'home#index'
  get 'home/index'
  get 'home/maintenance'

  # Login and logout routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # allow user data to be pulled for user/show
  resources :users, only: [:show, :edit, :update]

  # Create resourceful routes for transactions
  resources :transactions

  # Create resourceful routes for accounts only to show accounts, as user should not be able to do anything else
  resources :accounts
  resources :accounts, only: [:show] do
    resources :transactions, only: [:index, :new, :create]
  end

  # Create route for admins, so they can see pages like the dashboard
  resource :admins, only: [:show]

  # Create namespaces for admin, this will look like: 'admin/users' or 'admin/accounts', etc.
  namespace :admin do
    resources :users do
      member do
        get :delete
        get '/edit_password', action: :edit_password, controller: 'users'
        patch '/edit_password', action: :update_password, controller: 'users'
        #patch '/update_password', action: :update_password, controller: 'users'
      end
    end
    resources :accounts do
      member do
        get :delete
      end
    end
    resources :transactions do
      member do
        get :delete
      end
    end

    # Indented resourceful routes for better UX
    resources :users, only: [:show] do
      resources :transactions, only:  [:index, :new, :create]
    end

    resources :accounts, only: [:show] do
      resources :transactions, only:  [:index, :new, :create]
    end

    resources :users, only: [:show] do
      resources :accounts, only:  [:index, :new, :create]
    end
  end

end
