Ups::Application.routes.draw do
  resources :events do
    member do
      delete 'vote/:user_vote_id' => "events#user_vote_destroy", :as => :delete_user_votes
      put 'vote' => "events#vote", :as => :vote
      get 'timeslot/new' => "events#new_timeslot", :as => :new_timeslot
      delete 'timeslot/:timeslot_id' => "events#destroy_timeslot", :as => :destroy_timeslot
      get 'finish' => "events#finish", :as => :finish
      put 'reopen' => "events#reopen", :as => :reopen
      put 'finish' => "events#finished", :as => :finished
    end
  end

  match "/calendar" => "events#calendar", :via => :get
  match "/calendar/absence/new" => "events#new_absence", :via => :get, :as => :new_absence
  match "/calendar/absence" => "events#create_absence", :via => :post, :as => :create_absence
  resources :users
  resources :links
  resource :user, :only => :show, :as => :current_user
  
  resources :file_uploads, :except => [ :new, :show ] do
    collection do
      get ':page_id/new', :action => :new, :as => :new_with_page
    end
  end
  
  match "/downloads/:id" => "file_uploads#show", :as => :download_file

  match "/category/:id/(:name)" => "categories#show", :as => :show_category, :via => :get

  resources :session, :only => [] do
    collection do
      get :login
      get :start
      get :complete
      get :logout
    end
  end
  
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
    collection do
      post ':id/create_comment', :action => :create_comment, :as => :create_comment
      post ':id/create_comment_preview', :action => :create_comment_preview, :as => :create_comment_preview
    end
  end
  
  match "/config" => "conf#index", :via => :get
  match "/config" => "conf#update", :via => :put
  match "/config/check_twitter" => "conf#check_twitter", :via => :get
  match "/config/check_google" => "conf#check_google", :via => :get
  match "/config/create_google_calendar" => "conf#create_google_calendar", :via => :post
  match "/config/pull_github" => "conf#pull_github", :via => :get
  
  match "/credits" => "pages#credits"
  match "/setup" => "pages#setup"

  if Rails.env.development?
    match "/backdoor" => "users#backdoor", :via => :get
  end
  
  root :to => "pages#home"
  
  #match "*a" => "application#http_404"
end
