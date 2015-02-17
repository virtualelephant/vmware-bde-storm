#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default[:storm][:version]			= '0.9.0.1'
default[:storm][:workdir]			= '/var/storm'
default[:storm][:cluster_name]			= node[:cluster_name]

default[:storm][:zookeeper_port]		= 2181
default[:storm][:zookeeper_exhibitor_discovery]	= false
default[:storm][:zookeeper_exhibitor_url] 	= nil
