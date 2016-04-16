#
# Itamae recipe for Amazon EC2 instance
#

# --------------
#   Intall git
# --------------

package 'git' do
  action :install
end

# -----------------
#   Install nginx
# -----------------

package 'nginx' do
  action :install
  options "--nogpgcheck"
end

service 'nginx' do
  action :start
end

# -------------------
#   Install mongodb
# -------------------

remote_file "create mongodb-org repo file" do
  path "/etc/yum.repos.d/mongodb-org.repo"
  source "mongodb-org.repo"
end

package 'mongodb-org' do
  action :install
  options "--nogpgcheck"
end

service 'mongod' do
  action :start
end

# -----------------
#   Install redis
# -----------------

package "redis" do
  action :install
  options "--enablerepo=remi,remi-test,epel"
end

service 'redis-server' do
  action :start
end

