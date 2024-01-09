# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'
  
  resources :questions, shallow: true do
    resources :votes, defaults: { vottable: 'question'}, only: [:create, :destroy]
    resources :comments, defaults: { commentable: 'questions'}, only: [:create, :destroy], shallow: true
    resources :answers, shallow: true do
      resources :votes, defaults: { vottable: 'answer'}, only: [:create]
      resources :comments, defaults: { commentable: 'answers'}, only: [:create, :destroy], shallow: true
      delete '/vote', to: 'votes#destroy', defaults: { vottable: 'answer'}
    end
  end

  
  resources :files, only: :destroy

  resources :links, only: :destroy

  resources :awords, only: :index

  mount ActionCable.server => '/cable'
end
