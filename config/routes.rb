AdoptADrain::Application.routes.draw do

  resources :wards
  resources :municipals
  resources :need_help_categories
  resources :need_helps
  resources :authentications
  
  # TODO replace the below devise with 
  # devise_scope :user do ... end
  devise_for :users, :controllers => {
      :passwords => 'passwords',
      :registrations => 'users',
      :sessions => 'sessions',
  } do
    get 'forgot_password' => 'passwords#forgot'
    get 'users' => 'users#index'
    get 'add' => 'users#add'
    get 'profile' => 'users#profile'
    post 'users/account' => 'users#account'
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
  get '/search' => 'streets#search'
  post 'drains/flood' => 'drains#set_flood_prone'
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

      post '/users/role_requests' => 'users#requested_roles'
      post '/users/verify' => 'users#verify_leader'
      post '/users/deny' => 'users#deny'
      post '/users/remind' => 'users#remind'
      resources :users, only: [:index, :create, :show, :update, :destroy]

      get '/drains/data' => 'drains#data'
      get '/drains/ranking' => 'drains#ranking'
      resources :drains, only: [:index, :create, :show, :update, :history, :destroy] do
        get 'history', :on => :collection
      end

      get 'street_drains/:id' => 'drains#street_drains'
      resources :streets, only: [:index, :create, :show, :update, :destroy]


      post '/need_helps/status' => 'need_helps#update_status'
      post '/need_helps/filter' => 'need_helps#filter'
      resources :need_helps, only: [:index, :create, :show, :update, :destroy, :search, :autocomplete] do
        get 'search', :on => :collection
        get 'autocomplete', :on => :collection
      end

      get 'municipals/:id/wards' => 'municipals#wards'
      resources :municipals,only: [:index, :create, :show, :update, :destroy]

      get 'wards/:id/streets' => 'wards#streets'
      resources :wards, only: [:index, :create, :show, :update, :destroy]

    end
  end
end
