Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'pages#home'
  get '/pick_type', to: 'pages#pick_type'
  get '/new', to: 'pages#new'
  get '/professors', to: 'pages#professors'
  get '/professors/:id', to: 'pages#professor_show'
  get '/about_us', to: 'pages#about_us'
  get '/services', to: 'pages#services'
  get '/testimonies', to: 'pages#testimonies'
  get '/how_it_works', to: 'pages#how_it_works'
  get '/contact-us', to: 'pages#contact_us'
  get '/check-email', to: 'pages#check_email'
  get '/how-it-works', to: 'pages#how_it_works'
  get '/pricing', to:'pages#pricing'
  # get '/change-theme', to: 'application#set_theme'
  resources :contacts, only: [:create]

  resources :qnas do
    get :pick_type, on: :collection
    put :finish
    get :cancel
    resources :chats, only: [:show] do
      resources :messages, only: [:create], on: :collection
    end
  end

  devise_for :admins, path: 'admins', controllers: {
    sessions: 'admins/auth/sessions',
    registrations: 'admins/auth/registrations',
    passwords: 'admins/auth/passwords'
  }

  devise_for :tutors, path: 'tutors', controllers: {
    sessions: 'tutors/auth/sessions',
    registrations: 'tutors/auth/registrations',
    passwords: 'tutors/auth/passwords'
  }

  devise_for :managers, path: 'managers', controllers: {
    sessions: 'managers/auth/sessions',
    registrations: 'managers/auth/registrations',
    passwords: 'managers/auth/passwords'
  }

  devise_for :accountants, path: 'accountants', controllers: {
    sessions: 'accountants/auth/sessions',
    registrations: 'accountants/auth/registrations',
    passwords: 'accountants/auth/passwords'
  }

  devise_for :users, path: 'users', controllers: {
    sessions: 'users/auth/sessions',
    registrations: 'users/auth/registrations',
    passwords: 'users/auth/passwords'
  }

  devise_for :quality_officers, path: 'quality_officers', controllers: {
    sessions: 'quality_officers/auth/sessions'
    # registrations: 'quality_officers/auth/registrations',
    # passwords: 'quality_officers/auth/passwords'
  }

  namespace :admins do
    resources :homeworks, except: [:new, :create], on: :collection do
      put :assign
      put :finish_homework
      put :assign_tutor
      post :upload
    end
    resources :professors
    resources :prof_reviews, only: [:show, :update] do
      post :approve
    end
    resources :documents, only: [:index], on: :collection
    resources :managers, on: :collection
    resources :users, on: :collection
    resources :tutors, on: :collection
    resources :accountants, on: :collection
    resources :admins
    resources :chats, only: [:index]
    resources :quality_officers, on: :collection
    resources :qnas, only: [:index, :show], on: :collection do
      get :finish
    end
    get '/', to: 'dashboard#home'
  end

  namespace :quality_officers do
    resources :homeworks, only: [:index, :show] do
      post :upload
    end
    get '/', to: 'dashboard#home'
  end

  namespace :managers do
    resources :homeworks, only: [:index, :show, :update, :edit], on: :collection do
      post :upload
      put :approve
      put :assign_tutor
    end
    resources :chats, only: [:index]
    get '/', to: 'dashboard#home'
  end

  namespace :tutors do
    resources :homeworks, only: [:index, :show], on: :collection do
      get :add_bid
      get :edit_bid
      post :bid
      put :update_bid
      post :upload
      put :finish_homework
    end

    resources :qnas, only: [:index, :show] do
      put :assign
      put :cancel

      resources :messages, only: [:create]
      patch '/add_payment', to: 'qnas#add_payment', as: 'add_payment'
    end

    resources :chats, only: [:index]
    get '/', to: 'homeworks#index'
  end

  namespace :users do
    resources :homeworks, on: :collection do
      get :success
      get :pick_type, on: :collection

      patch '/edit', to: 'homeworks#update', as: 'update_homework'
      get '/submit_homework', to: 'homeworks#submit_homework', as: 'submit_homework'

      get '/delete_draft', to: 'homeworks#delete_draft', as: 'delete_draft'
    end
    post 'homeworks/add_to_draft', to: 'homeworks#add_to_drafts', as: 'add_to_drafts'

    resources :professors, only: [:index, :show, :new, :create] do
      get :search, on: :collection
    end

    resources :qnas do
      get :finish
      get :cancel
      resources :chats, only: [:show] do
        resources :messages, only: [:create], on: :collection
      end
    end

    get 'profile', to: 'users#show'
    resources :chats, only: [:index]
    get '/', to: 'dashboard#home'
  end

  namespace :accountants do
    resources :homeworks, only: [:index, :show, :update], on: :collection
    get '/', to: 'dashboard#home'
  end
  get '/cheko-ai' => 'gpt3#index'
  post '/gpt3/generate' => 'gpt3#generate'
  post '/gpt3/rewrite' => 'gpt3#rewrite'
  post '/gpt3/humanize' => 'gpt3#humanize'
  post '/gpt3/update_title' => 'gpt3#update_title'
  post '/gpt3/update_conversation' => 'gpt3#update_conversation'
  post '/gpt3/save_conversation' => 'gpt3#save_conversation'
  post '/gpt3/delete_conversation' => 'gpt3#delete_conversation'
  get '/gpt3/render_better_answer_bubble' => 'gpt3#render_better_answer_bubble'
end
