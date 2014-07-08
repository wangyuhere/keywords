Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :words, only: [:index, :show]
  resources :articles, only: [:index, :show]
  get :statistics, to: 'statistics#index'
  get :trends, to: 'trends#index'
  get 'days', to: 'days#index'
  get 'days/:date', to: 'days#show', as: 'day'
  root 'words#index'
end
