Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  
  resources :wards
  resources :municipals
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
      resources :drains,only: [:index, :create, :show, :update, :destroy]

      get 'street_drains/:id' => 'drains#street_drains'
      resources :streets,only: [:index, :create, :show, :update, :destroy]


      post '/need_helps/status' => 'need_helps#update_status'
      post '/need_helps/search' => 'need_helps#search'
      resources :need_helps,only: [:index, :create, :show, :update, :destroy]

      get 'municipals/:id/wards' => 'municipals#wards'
      resources :municipals,only: [:index, :create, :show, :update, :destroy]

      get 'wards/:id/streets' => 'wards#streets'
      resources :wards,only: [:index, :create, :show, :update, :destroy]

    end
  end
end
