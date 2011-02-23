Ups::Application.routes.draw do
  #resources :pages, :constraints => {:int_title => /[a-z_]{0,255}/}
  
  match "/page/:id/:int_title" => "pages#show", :as => :show_page, :via => :get
  
  resources :pages
  
  match "/credits" => "pages#credits"
  
  root :to => "pages#home"
  
end
