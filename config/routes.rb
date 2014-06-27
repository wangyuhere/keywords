Rails.application.routes.draw do
  resources :words, only: [:index, :show]
  root 'words#index'
end
