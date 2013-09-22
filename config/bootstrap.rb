require "rvm/capistrano"
require 'capistrano/ext/multistage'

namespace :bootstrap do
  task :default do
    # Specific RVM string for managing Puppet; may or may not match the RVM string for the application
    set :user, "root"

    # Set the default_shell to "bash" so that we don't use the RVM shell which isn't installed yet...
    set :default_shell, "bash"

    # We tar up the puppet directory from the current directory -- the puppet directory within the source code repository
    system("tar czf 'puppet.tgz' puppet/")
    upload("puppet.tgz","/srv/",:via => :scp)

    # Untar the puppet directory, and place at /etc/puppet -- the default location for manifests/modules
    run("tar xzf puppet.tgz")
    try_sudo("rm -rf /etc/puppet")
    try_sudo("mv /srv/puppet/ /etc/puppet")

    # Bootstrap RVM/Puppet!
    try_sudo("bash /etc/puppet/bootstrap.sh")
  end
end

namespace :puppet do
  task :default do
    # Specific RVM string for managing Puppet; may or may not match the RVM string for the application
    set :rvm_ruby_string, '1.9.3-p125'
    set :rvm_type, :system
    set :user, "root"

    # We tar up the puppet directory from the current directory -- the puppet directory within the source code repository
    system("tar czf 'puppet.tgz' puppet/")
    upload("puppet.tgz","/srv/",:via => :scp)

    # Untar the puppet directory, and place at /etc/puppet -- the default location for manifests/modules
    run("tar xzf puppet.tgz")
    try_sudo("rm -rf /etc/puppet")
    try_sudo("mv puppet/ /etc/puppet")

    # Run RVM/Puppet!
    run("rvmsudo -p '#{sudo_prompt}' puppet apply /etc/puppet/manifests/site.pp")
  end
end
