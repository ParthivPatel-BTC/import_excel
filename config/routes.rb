Rails.application.routes.draw do
  root to: 'products#index'

  get '/products/check_status' => 'products#check_status'
  resources :products
end
