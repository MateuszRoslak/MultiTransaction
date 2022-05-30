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

  resource :checkout, only: [:create] do
    collection do
      get :success
    end
  end

  root 'pages#home'
end
