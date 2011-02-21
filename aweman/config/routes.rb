Aweman::Application.routes.draw do
  resources :clients

  resources :projects

  resources :groups

  resources :users
end
