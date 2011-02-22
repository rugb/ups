module ProjectsHelper
  def clients_options
    Client.all.collect { |c| [c.to_s, c.id] }
  end
end
