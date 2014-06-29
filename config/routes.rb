Rails.application.routes.draw do
  resources :words, only: [:index, :show]
  resources :articles, only: [:index, :show]
  get :statistics, to: 'statistics#index'
  get :trends, to: 'trends#index'
  root 'words#index'
end
