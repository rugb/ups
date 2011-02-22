Aweman::Application.routes.draw do
  resources :clients

  resources :projects do
    member do
      post :add_group
      delete :remove_group
    end
  end

  resources :groups

  resources :users do
    member do
      post :group_with
    end
  end

  root :to => 'users#index'
end
