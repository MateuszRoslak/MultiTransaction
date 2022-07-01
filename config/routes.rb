# frozen_string_literal: true

Rails.application.routes.draw do

  devise_scope :user do
    # Redirects signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }

  # For admins
  authenticate :user, ->(user) { user.has_role? :admin } do
    namespace :admin do

      resources :products do
        member do
          put :toggle_active
        end

        resources :product_discounts
      end

      get '/', to: 'products#index'
    end
  end

  resources :products, only: %i[index show] do
    member do
      post :add_to_cart
    end
  end

  resource :cart, only: %i[show destroy update] do
    collection do
      get :summary
    end
  end

  resources :cards, only: %i[index destroy new create]

  resource :checkout, only: [:create] do
    collection do
      post :retry
    end
  end

  resources :orders, only: [:index, :show]

  namespace :stripe_payments do
    resources :webhooks, only: [] do
      post :process_event, on: :collection
    end
  end

  get '/401', to: 'errors#unauthorized'
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_error'

  root 'pages#home'
end
