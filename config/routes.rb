# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks'}

  resources :authorizations, only: [:create, :new] 

  root to: 'questions#index'


  
  resources :questions, shallow: true do
       
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
end
