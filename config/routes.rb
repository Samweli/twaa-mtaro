AdoptASidewalk::Application.routes.draw do
  resources :authentications

  devise_for :users, :controllers => {
      :passwords => 'passwords',
      :registrations => 'users',
      :sessions => 'sessions',
  }
  get 'address' => 'addresses#show', :as => 'address'
  get 'address_report' => 'addresses#report', :as => 'address_report'
  get 'tos' => 'main#tos', :as => 'tos'
  get 'sidebar' => 'main#sidebar', :as => 'sidebar'

  match '/auth/:provider/callback' => 'authentications#create'
  
  resources :sidewalks
  resources :sidewalk_claims
  root :to => 'main#index'
end
