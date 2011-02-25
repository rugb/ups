Ups::Application.routes.draw do

  match "/category/:id/(:name)" => "categories#show", :as => :show_category, :via => :get

  get "session/login"
  get "session/start"
  get "session/complete"
  get "session/logout"
  get "session/show"

  #resources :pages, :constraints => {:int_title => /[a-z_]{0,255}/}
  
  match "/page/:id/(:int_title)(/:language_short)" => "pages#show", :as => :show_page, :via => :get
  
  resources :categories do
    delete 'delete' => "categories#destroy", :on => :member
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
  
  
  
#   map.with_options :controller => 'session' do |openid|
#    openid.openid_start 'openid/start', :action => 'start'
#    openid.openid_complete 'openid/complete', :action => 'complete'
#   end

  
  match "/credits" => "pages#credits"
  match "/setup" => "pages#setup"
  
  root :to => "pages#home"
  
end
