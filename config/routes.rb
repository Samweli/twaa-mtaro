AdoptADrain::Application.routes.draw do
  resources :need_help_categories
  resources :need_helps
  resources :authentications

  devise_for :users, :controllers => {
      :passwords => 'passwords',
      :registrations => 'users',
      :sessions => 'sessions',
  } do
    get 'forgot_password' => 'passwords#forgot'
    get 'users' => 'users#index'
    get 'add' => 'users#add'
    get 'profile' => 'users#profile'
    post 'createuser' => 'users#createuser'
    put 'update' => 'users#update'
  end

  get 'address' => 'addresses#show', :as => 'address'
  get 'address_report' => 'addresses#report'
  get 'tos' => 'main#tos'
  get 'user_list' => 'drain_claims#user_list'
  get 'sidebar' => 'main#sidebar'
  get '/sms/new' => 'sms#new'
  get 'drain_claims/adopt' => 'drain_claims#adopt'
  post '/streets/add_drain' => 'streets#add_drain'

  match '/auth/:provider/callback' => 'authentications#create'

  resources :drains do
    get 'find_closest', :on => :collection
  end
  resources :drain_claims

  root :to => 'main#index'

  #api
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'registrations' => 'registrations#create', :as => 'register'
        post 'sessions' => 'sessions#create', :as => 'login'
        delete 'sessions' => 'sessions#destroy', :as => 'logout'
      end

      get '/drains/data' => 'drains#data'
      get '/drains/ranking' => 'drains#ranking'
      get 'street_drains/:id' => 'drains#street_drains'
      get '/users/new_leaders' => 'users#leader_requests'
      post '/users/verify' => 'users#verify_leader'
      post '/users/remind' => 'users#remind'
      resources :users, only: [:index, :create, :show, :update, :destroy]
      resources :drains,only: [:index, :create, :show, :update, :destroy]
      resources :streets,only: [:index, :create, :show, :update, :destroy]
      resources :need_helps,only: [:index, :create, :show, :update, :destroy]

    end
  end
end
