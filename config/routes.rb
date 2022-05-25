Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resource :checkout, only: [:show] do
    collection do
      get :success
      get :history
      get :order
    end
  end

  resources :products, only: [:index, :show]

  root 'pages#home'
end
