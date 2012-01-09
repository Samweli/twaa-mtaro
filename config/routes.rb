AdoptAThing::Application.routes.draw do
  devise_for :users, :controllers => {
      :passwords => 'passwords',
      :registrations => 'users',
      :sessions => 'sessions',
  }
  get 'address' => 'addresses#show', :as => 'address'
  get 'info_window' => 'info_window#index', :as => 'info_window'
  get 'sitemap' => 'sitemaps#index', :as => 'sitemap'
  get 'tos' => 'info_window#tos', :as => 'tos'
  resources :sidewalks
  resources :sidewalk_claims
  root :to => 'main#index'
end
