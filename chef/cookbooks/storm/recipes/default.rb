#
# Cookbook Name:: storm
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe "java::sun"
include_recipe "hadoop_common::pre_run"
include_recipe "hadoop_common::mount_disks"
include_recipe "hadoop_cluster::update_attributes"

# Get the 0MQ repo information
remote_file "/etc/yum.repos.d/zeromq.repo" do
  source "http://download.opensuse.org/repositories/home:/fengshuo:/zeromq/CentOS_CentOS-6/home:fengshuo:zeromq.repo"
  action :create
end

# Install EPEL repo
remote_file "/tmp/epel-release-6-8.noarch.rpm" do
  source "http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"
  action :create
end

package "epel" do
  action :install
  source "/tmp/epel-release-6-8.noarch.rpm"
  provider Chef::Provider::Package::Rpm
end

remote_file "/tmp/jzmq-master.zip" do
  source "https://hadoop-mgmt.or1.omniture.com/yum/repos/jzmq-master.zip"
  action :create
end

# Dependency packages
%w{gcc gcc-c++ libtool libuuid-devel make unzip python automake zeromq zeromq-devel supervisor}.each do |pkg|
  package pkg do
    action :install
  end
end

# jzmq binding has no available RPM, must be installed from source
script "install_jzmq" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
    unzip /tmp/jzmq-master.zip
    cd jzmq-master
    ./autogen.sh
    ./configure 
    make install
  EOH
end

# User and Group
group "storm"
user "storm" do
  comment "Storm User"
  gid "storm"
  shell "/bin/bash"
  home "/home/storm"
  supports :manage_home => true
end

clear_bootstrap_action
