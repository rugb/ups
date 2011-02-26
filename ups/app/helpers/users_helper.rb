module UsersHelper
  def role_options
    Role.all.collect { |r| [r.to_s, r.id] }
  end

  def language_options
    Language.all.collect { |l| [l.to_s, l.id] }
  end
end
