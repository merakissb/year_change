Rails.application.routes.draw do
  resources :excel_files
  devise_for :users
  root to:'excel_files#index'
  get '/excel_files/:id/validate_file', to: 'excel_files#validate_file', as: 'validate_excel_file'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end