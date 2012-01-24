AdoptASidewalk::Application.routes.draw do
  resources :authentications

  devise_for :users, :controllers => {
      :passwords => 'passwords',
      :registrations => 'users',
      :sessions => 'sessions',
  } do
    get 'forgot_password' => 'passwords#forgot'
  end
  
  get 'address' => 'addresses#show', :as => 'address'
  get 'address_report' => 'addresses#report'
  get 'tos' => 'main#tos'
  get 'sidebar' => 'main#sidebar'

  match '/auth/:provider/callback' => 'authentications#create'
  
  resources :sidewalks do
    get 'find_closest', :on => :collection
  end
  resources :sidewalk_claims
  root :to => 'main#index'
end
