authorization do
  role :guest do
    has_permission_on :authorization_rules, :to => :read
    has_permission_on :authorization_usages, :to => :read
    
    has_permission_on :session, :to => :login
    has_permission_on :session, :to => :info
  end
  
  role :user do
    
    
    has_permission_on :session, :to => :info
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
