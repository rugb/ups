Ups::Application.routes.draw do
  resources :users
  resources :links

  match "/file_uploads/:page_id/new" => "file_uploads#new", :as => :new_file_upload_with_page, :via => :get
  match "/file_uploads" => "file_uploads#create", :as => :file_uploads, :via => :post
  match "/downloads/:id" => "file_uploads#show", :as => :download_file
  match "/file_uploads/:id/edit" => "file_uploads#edit", :as => :edit_file_upload, :via => :get
  match "/file_uploads/:id" => "file_uploads#update", :as => :file_upload, :via => :put
  match "/file_uploads/:id" => "file_uploads#destroy", :as => :file_upload, :via => :delete
  match "/file_uploads" => "file_uploads#index", :as => :file_uploads, :via => :get
  
  
  #resources :file_uploads
  
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
  
  match "/blog/:id/(:int_title)(/:language_short)" => "news#show", :as => :show_news, :via => :get
  match "/blog/:id/(:int_title)(/:language_short)" => "news#destroy", :as => :show_news, :via => :delete
  match "/blog/:id/(:int_title)(/:language_short)" => "news#update", :as => :show_news, :via => :put
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
    end
  end
  
  match "/config" => "conf#index", :via => :get
  match "/config" => "conf#update", :via => :put
  
  match "/credits" => "pages#credits"
  match "/setup" => "pages#setup"
  
  root :to => "pages#home"
  
  #match "*a" => "application#http_404"
end
