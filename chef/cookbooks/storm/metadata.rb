maintainer	 "Chris Mutchler"
maintainer_email "chris@virtualelephant.com"
license		 "Apache 2.0"
description	 "Installs/Configures Apache Storm cluster"
version		 "0.1.1"

description	 "Installs/Configures Apache Storm stack"

depends		 "java"
depends		 "install_from"
depends		 "cluster_service_discovery"
depends		 "hadoop_common"
depends		 "hadoop_cluster"

recipe		 "storm::default", "Install/Configure Apache Storm"

%w{ redhat centos}.each do |os|
  supports os
end
