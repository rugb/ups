Ups::Application.routes.draw do
  #resources :pages, :constraints => {:int_title => /[a-z_]{0,255}/}
  
  match "/page/:id/(:int_title)(/:language_short)" => "pages#show", :as => :show_page, :via => :get
  
  resources :pages do
    member do
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
