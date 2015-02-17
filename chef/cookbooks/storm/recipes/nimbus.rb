# Cookbook Name:: storm::nimbus
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

node.default[:storm][:zookeeper_server_list] = zookeepers_ip

include_recipe "hadoop_cluster::update_attributes"

# Get the Storm package
remote_file "/tmp/storm-0.9.3.tar.gz" do
  source "http://mirrors.koehn.com/apache/storm/apache-storm-0.9.3/apache-storm-0.9.3.tar.gz"
  action :create
end

script "install_storm" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
    tar zxvf /tmp/storm-0.9.3.tar.gz
    mv apache-storm-0.9.3 /opt/
    ln -s /opt/apache-storm-0.9.3 /opt/storm
    mkdir -p /var/storm
  EOH
end

run_in_ruby_block "DEBUG BLOCK" do
  node.default[:storm][:zookeeper_server_list].each do |zk|
    $stderr.puts zk
  end
  node.default[:storm][:nimbus][:ipaddr] = ip_of_hdfs_network(node)
  $stderr.puts "Nimbus node:"
  $stderr.puts "#{node.default[:storm][:nimbus][:ipaddr]}"
end

if node.default[:storm][:zookeeper_server_list].count > 0
  zk_server_list = node.default[:storm][:zookeeper_server_list]
end

unless zk_server_list.nil?
  Chef::Log.info("Zookeeper Server List: #{zk_server_list}")

  template '/opt/storm/conf/storm.yaml' do
    source 'storm.yaml.erb'
    variables(
	zookeeper_server_list: zk_server_list,
	config: node.default[:storm][:nimbus]
    )
    action :create
  end
end

template '/etc/supervisord.conf' do
  source 'supervisord.conf.erb'
  action :create
end

execute 'set supervisord runlevels' do
  command 'chkconfig supervisord on'
end

execute 'start supervisord service' do
  command 'service supervisord start'
end
