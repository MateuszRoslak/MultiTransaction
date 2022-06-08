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

  resource :cart, only: [:show, :destroy, :update]

  resource :cards, only: [:show, :destroy, :new, :create]

  resource :checkout, only: [:create] do
    collection do
      get :success
    end
  end

  resources :orders, only: [:index, :show]

  root 'pages#home'
end
