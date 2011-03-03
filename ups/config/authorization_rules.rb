authorization do
  role :guest do
    has_permission_on :session, :to => [ :start, :login ]

    has_permission_on :pages, :to => [ :show, :credits, :setup ] do
      if_attribute :role => { :int_name => is  { user.role.int_title } }
    end

    has_permission_on :file_uploads, :to => :show do
      if_attribute :page => { :role => { :int_name => is { user.role.int_title } } }
    end

    has_permission_on :news, :to => [ :index, :show, :rss ]
    has_permission_on :pages, :to => :home
    has_permission_on :categories, :to => [ :show ]

    has_permission_on :users, :to => :backdoor if Rails.env.development?
  end
  
  role :user do
    includes :guest

    has_permission_on :users, :to => [ :edit, :update ] do
      if_attribute :id => is { user.id } 
    end

    has_permission_on :users, :to => :show
    has_permission_on :session, :to => [ :show, :logout ]
  end

  role :member do
    includes :user

    has_permission_on :pages, :to => [:index, :new, :create]
    has_permission_on :pages, :to => [:edit, :update] do
      if_attribute :edit_role => { :int_name => is { user.role.int_title } }
    end

    has_permission_on :news, :to => [ :new, :create ]
    has_permission_on :news, :to => [ :edit, :update ] do
      if_attribute :user_id => is { user.id }
    end

    has_permission_on :file_uploads, :to => [ :new, :create ]
    has_permission_on :file_uploads, :to => [ :edit, :update, :destroy ] do
      if_attribute :page => { :user_id => is { user.id } }
    end

    has_permission_on :events, :to => [ :new, :create, :show, :index, :calendar ]
    has_permission_on :events, :to => [ :edit, :update ] do
      if_attribute :user_id => is { user.id }
    end
    has_permission_on :events, :to => [ :user_vote_destroy ] do
      if_attribute :user_id => is { user.id }
    end
    has_permission_on :events, :to => :vote do
      if_attribute :finished => false
    end
  end
  
  role :admin do
    includes :member

    has_omnipotence

#     has_permission_on :authorization_rules, :to => :read
#     has_permission_on :authorization_usages, :to => :read
  end
  
#   role :user do
#     includes :guest
#     has_permission_on :users, :to => :manage do
#       if_attribute :id => is {user.id}
#     end
#   end
end

 
# privileges do
#   privilege :manage, :includes => [:create, :read, :update, :delete]
#   privilege :read,   :includes => [:index, :show]
#   privilege :create, :includes => :new
#   privilege :update, :includes => :edit
#   privilege :delete, :includes => :destroy
#  end
