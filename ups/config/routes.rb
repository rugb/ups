Ups::Application.routes.draw do
  #resources :pages, :constraints => {:int_title => /[a-z_]{0,255}/}
  
  match "/pages/:id/:int_title" => "pages#show", :as => :show_page, :via => :get
  
  resources :pages

  root :to => "pages#home"
  
end
