# frozen_string_literal: true
require 'sidekiq/web'
Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks'}

  resources :authorizations, only: [:create, :new] 

  root to: 'questions#index'


  
  resources :questions, shallow: true do

    resources :subscriptions, only: [:destroy]
    post 'create_subscription' => 'subscriptions#create_subscription' 
    
    post '/vote/' => 'votes#vote', as: :vote, defaults: { vottable: 'question'}
    resources :votes, only: :destroy
    
    resources :comments, defaults: { commentable: 'questions'}, only: :create

    resources :answers, shallow: true do
      post '/vote/' => 'votes#vote', as: :vote, defaults: { vottable: 'answer'}

      member do
        patch :set_best, to: 'answers#set_best'
      end

      resources :comments, defaults: { commentable: 'answers'}, only: :create, shallow: true
    end
  end

  resources :files, only: :destroy

  resources :links, only: :destroy

  resources :awords, only: :index

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:index, :show, :create, :update, :destroy] 
      end
    end
  end
end
