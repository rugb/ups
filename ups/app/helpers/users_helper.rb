module UsersHelper
  def role_options
    Role.all.collect { |r| [ r.to_s, r.id] }
  end
end
