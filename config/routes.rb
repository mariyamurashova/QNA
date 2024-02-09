# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks'}

  resources :authorizations, only: [:create, :new] 

  root to: 'questions#index'

  #post '/questions/:id/vote/' => 'votes#vote', as: :question, defaults: { vottable: 'question'}
  post '/answers/:id/votes/' => 'votes#vote', as: :vote_answer,  defaults: { vottable: 'answer'}
  
  resources :questions, shallow: true do
    post '/vote/' => 'votes#vote', as: :vote, defaults: { vottable: 'question'}
    resources :votes, defaults: { vottable: 'question'}, only: [:destroy]

    post '/comment/' => 'comments#comment', as: :comment, defaults: { commentable: 'question'}
    resources :comments, defaults: { commentable: 'questions'}, only: [:destroy], shallow: true
    resources :answers, shallow: true do
      post '/vote/' => 'votes#vote', as: :vote, defaults: { vottable: 'answer'}
      resources :votes, defaults: { vottable: 'answer'}, only: [:destroy]

      member do
        patch :set_best, to: 'answers#set_best'
      end

      post '/comment/' => 'comments#comment', as: :comment, defaults: { commentable: 'answer'}
      resources :comments, defaults: { commentable: 'answers'}, only: [:create, :destroy], shallow: true
      #delete '/vote', to: 'votes#destroy', defaults: { vottable: 'answer'}
    end
  end

  resources :files, only: :destroy

  resources :links, only: :destroy

  resources :awords, only: :index

  mount ActionCable.server => '/cable'
end
