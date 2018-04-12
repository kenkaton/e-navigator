Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root 'users#index', as: :authenticated_root
    end
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  resources :users
  resources :users do
    resources :interviews do
      post :apply, on: :collection
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
