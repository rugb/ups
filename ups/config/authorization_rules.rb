authorization do
  role :guest do
    has_permission_on :session, :to => :login
    has_permission_on :session, :to => :start

    has_permission_on :pages do #, :to => :show
      to :show, :credits, :setup
      if_attribute :role => { :int_name => is  { :guest } }
    end
    
    has_permission_on :pages, :to => :home
  end
  
  role :user do
    includes :guest

    has_permission_on :pages do #, :to => :show
      to :show
      if_attribute :role => { :int_name => is  { :user } }
    end

    has_permission_on :users do
      to :edit, :update
      if_attribute :id => is { user.id } 
    end

    has_permission_on :users, :to => :show
    
    has_permission_on :session, :to => :show
    has_permission_on :session, :to => :logout
  end

  role :member do
    includes :user

    has_permission_on :pages do #, :to => :show
      to :show
      if_attribute :role => { :int_name => is  { :member } }
    end
  end

  role :admin do
    includes :member

    has_omnipotence
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
