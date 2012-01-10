AdoptAThing::Application.routes.draw do
  devise_for :users, :controllers => {
      :passwords => 'passwords',
      :registrations => 'users',
      :sessions => 'sessions',
  }
  get 'address' => 'addresses#show', :as => 'address'
  get 'address_report' => 'addresses#report', :as => 'address_report'
  get 'tos' => 'info_window#tos', :as => 'tos'
  resources :sidewalks
  resources :sidewalk_claims
  root :to => 'main#index'
end
