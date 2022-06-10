Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :products, only: [:index, :show] do
    member do
      post :add_to_cart
    end
  end

  resource :cart, only: [:show, :destroy, :update] do
    collection do
      get :summary
    end
  end

  resource :cards, only: [:show, :destroy, :new, :create]

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

  root 'pages#home'
end
