Rails.application.routes.draw do
  resources :excel_files
  devise_for :users
  root to:'excel_files#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end