#
# Itamae recipe for chat-api-server deployment
# [Aimed for CentOS]
#

# ----------------------
#   Nginx installation
# ----------------------

execute "Register repo and install the latest nginx" do
  only_if "test -e /etc/redhat-release"
  command "rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm"
end

package "nginx" do
  not_if "test -e /etc/redhat-release"
  action :install
end

# ------------------------
#   MongoDB installation
# ------------------------

# http://kzy52.com/entry/2015/05/13/085650
execute "Register repo and install the latest mongodb" do
  only_if "test -e /etc/redhat-release"
  command "echo \
    [mongodb-org] \
    name=MongoDB Repository \ 
    baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/ \
    gpgpackage=0 \
    enabled=1 \
  > /etc/yum.repos.d/mongodb-org.repo"
  command "yum install -y mongodb-org"
end

package "mongodb" do
  not_if "test -e /etc/redhat-release"
  action :install
end

# ----------------------
#   Redis installation
# ----------------------

# Update redis repl only if the current platform is CentOS
execute "Register repo and install the latest redis" do
  only_if "test -e /etc/redhat-release"
  command "rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
  command "rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm"
  command "rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
  command "yum --enablerepo=remi,remi-test,epel install redis"
end

# If the current platform is not CentOS, just install redis with the package manager
package "redis" do
  not_if "test -e /etc/redhat-release"
  action :install
end


