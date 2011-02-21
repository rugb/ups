Aweman::Application.routes.draw do
  resources :clients

  resources :projects

  resources :groups

  resources :users do
    member do
      post :group_with
    end
  end
end
