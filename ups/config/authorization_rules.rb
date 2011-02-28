authorization do
  role :guest do
    has_permission_on :session, :to => [ :start, :login ]

    has_permission_on :pages do
      to :show, :credits, :setup
      if_attribute :role => { :int_name => is  { :guest } }
    end

    has_permission_on :news, :to => [ :index, :show, :rss ]
    has_permission_on :pages, :to => :home
    has_permission_on :categories, :to => [ :index, :show ]

    has_permission_on :file_uploads do
      to :show
      if_attribute :page => { :role => { :int_name => is { :guest } } }
    end
  end
  
  role :user do
    includes :guest

    has_permission_on :pages do
      to :show
      if_attribute :role => { :int_name => is  { :user } }
    end

    has_permission_on :users do
      to :edit, :update
      if_attribute :id => is { user.id } 
    end

    has_permission_on :users, :to => :show
    
    has_permission_on :session, :to => [ :show, :logout ]

    has_permission_on :file_uploads do
      to :show
      if_attribute :page => { :role => { :int_name => is { :user } } }
    end
  end

  role :member do
    includes :user

    has_permission_on :pages do
      to :show
      if_attribute :role => { :int_name => is  { :member } }
    end

    has_permission_on :file_uploads do 
      to :show
      if_attribute :page => { :role => { :int_name => is { :member } } }
    end

    has_permission_on :news do
      to :edit, :update
      if_attribute :user_id => is { user.id }
    end

    has_permission_on :news, :to => [ :new, :create ]

    has_permission_on :file_uploads, :to => [ :new, :create, :edit, :update, :destroy ]
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
