module UsersHelper
  def free_users_options(user)
    User.free_users(user).collect {|u| [u.name, u.id] }
  end
end
