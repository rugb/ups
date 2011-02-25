Ups::Application.routes.draw do
  match "/category/:id/(:name)" => "categories#show", :as => :show_category, :via => :get
  match "/category/:id/(:name)" => "categories#update", :as => :show_category, :via => :put
  match "/page/:id/(:int_title)(/:language_short)" => "pages#show", :as => :show_page, :via => :get
  
  resources :news
  resources :categories do
    member do
      delete 'delete' => "categories#destroy"
    end
  end
  resources :pages do
    member do
      get 'activate'
      get 'deactivate'
      
      match 'new_content/:language_id' => "page_content#new", :via => :get, :as => :new_page_content
      match 'create_content/:language_id' => "page_content#create", :via => :post, :as => :create_page_content
      match 'edit_content/:language_id' => "page_content#edit", :via => :get, :as => :edit_page_content
      match 'update_content/:language_id' => "page_content#update", :via => :put, :as => :update_page_content
      match 'destroy_content/:language_id' => "page_content#destroy", :via => :delete, :as => :destroy_page_content
    end
  end
  
  match "/credits" => "pages#credits"
  match "/setup" => "pages#setup"
  
  root :to => "pages#home"
  
end
