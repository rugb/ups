Ups::Application.routes.draw do
  resources :users
  
#   get "user/index"
#   get "user/show"
#   get "user/new"
#   get "user/create"
#   get "user/update"
#   get "user/edit"
#   get "user/destroy"

  match "/category/:id/(:name)" => "categories#show", :as => :show_category,
    :via => :get
  
  get "session/login"
  get "session/start"
  get "session/complete"
  get "session/logout"
  get "session/show"
  
  #resources :pages, :constraints => {:int_title => /[a-z_]{0,255}/}
  
  match "/category/:id/(:name)" => "categories#update", :as => :show_category, :via => :put
  
  match "/page/:id/(:int_title)(/:language_short)" => "pages#show", :as => :show_page, :via => :get
  
  resources :news do
    get 'rss', :on => :collection
  end
  resources :categories do
    member do
      delete 'delete' => "categories#destroy"
    end
  end
  resources :pages do
    member do
      get 'activate'
      get 'deactivate'
      
      match 'new_content/:language_id' => "page_contents#new", :via => :get, :as => :new_page_content
      match 'create_content/:language_id' => "page_contents#create", :via => :post, :as => :create_page_content
      match 'edit_content/:language_id' => "page_contents#edit", :via => :get, :as => :edit_page_content
      match 'update_content/:language_id' => "page_contents#update", :via => :put, :as => :update_page_content
      match 'destroy_content/:language_id' => "page_contents#destroy", :via => :delete, :as => :destroy_page_content
    end
  end
  
  match "/config" => "conf#index", :via => :get
  match "/config" => "conf#update", :via => :put
  
  match "/credits" => "pages#credits"
  match "/setup" => "pages#setup"
  
  root :to => "pages#home"
  
  #match "*a" => "application#http_404"
end
