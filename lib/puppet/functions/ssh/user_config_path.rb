Puppet::Function.create_function(:'ssh::user_config_path') do
  def user_config_path(user)
    resource = catalog.resources.find { |r| r.is_a?(Puppet::Type.type(:user)) && r[:name] == user }

    home = if resource
             resource[:home] || Dir.home(resource[:name])
           else
             Dir.home(user)
           end

    File.join(home, '.ssh', 'config')
  end
end
