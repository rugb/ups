module UsersHelper
  def free_users_options(user)
    User.free_users(user).collect {|u| [u.name, u.id] }
  end
  
  def groups_options
    Group.all.collect {|u| [u.nr.to_s, u.id] }
  end
end
