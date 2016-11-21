#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'httpd' do
   action :install
end

package 'httpd-devel' do
   action :install
end

package 'mysql-server' do 
   action :install
   source "/tmp/kitchen/cookbooks/zabbix/files/default/mysql-server.noarch.rpm"
   provider Chef::Provider::Package::Rpm
end

package 'mysql' do
   action :install
end

yum_package 'mysql-server' do
   action :install
end

service 'mysql' do
   action [:start, :enable]
end

package 'php-mysql' do
   action :install
end

package 'php-pear' do
   action :install
end

#service 'mysql' do
#   action :start
#end

execute 'run service mysql' do
   command "sudo systemctl start mysql"
   action :run
end

bash 'set mysql' do
  action :run
  user "root"
  cwd "/tmp"
  code <<-EOH
    sudo mysql --execute="SET PASSWORD FOR #{node['mysql']['DBUser']}@'localhost' = PASSWORD('#{node['mysql']['DBPassword']}');"
    mysql -u #{node['mysql']['DBUser']} -p#{node['mysql']['DBPassword']} --execute="CREATE DATABASE #{node['mysql']['DBName']} CHARACTER SET UTF8; GRANT ALL PRIVILEGES on #{node['mysql']['DBName']}.* to #{node['mysql']['zabbix_server']['DBUser']} IDENTIFIED BY '#{node['mysql']['zabbix_server']['DBPassword']}'; FLUSH PRIVILEGES;"
    mysql -u #{node['zabbix_server']['DBUser']} -p#{node['mysql']['zabbix_server']['DBPassword']} #{node['zabbix_server']['DBName']} < /tmp/kitchen/cookbooks/zabbix/files/default/schema.sql
    mysql -u #{node['zabbix_server']['DBUser']} -p#{node['mysql']['zabbix_server']['DBPassword']} #{node['zabbix_server']['DBName']} < /tmp/kitchen/cookbooks/zabbix/files/default/data.sql
     mysql -u #{node['zabbix_server']['DBUser']} -p#{node['mysql']['zabbix_server']['DBPassword']} #{node['zabbix_server']['DBName']} < /tmp/kitchen/cookbooks/zabbix/files/default/images.sql
  EOH
end
#mysql -u zabbixuser -p zabbixdb < /usr/share/doc/zabbix-server-mysql-2.4.5/create/schema.sql

package 'zabbix-agent' do
  source "/tmp/kitchen/cookbooks/zabbix/files/default/zabbix-3.2.noarch.rpm"
  provider Chef::Provider::Package::Rpm
  action :install
end

yum_package 'zabbix-agent' do 
  action :install
end

package 'zabbix-server' do
   action :install
end

package 'zabbix-web-mysql' do
   action :install
end

package 'zabbix-java-gateway' do
   action :install
end

template '/etc/httpd/conf.d/zabbix.conf' do
   source 'zabbix.conf.erb'
   owner 'root'
   group 'root'
   mode '0644'
end

service 'httpd' do
   action [:start, :enable]
end

file '/etc/zabbix/zabbix_agentd.conf' do
   action :delete
end

template '/etc/zabbix/zabbix_agentd.conf' do
   source 'zabbix_agentd.conf.erb'
   owner 'root'
   group 'root'
   mode '0644'
end

file '/etc/zabbix/zabbix_java-gateway.conf' do
   action :delete
end

template '/etc/zabbix/zabbix_java_gateway.conf' do
   source 'zabbix_java_gateway.conf.erb'
   owner 'root'
   group 'root'
   mode '0644'
end

file '/etc/zabbix/zabbix_server.conf' do
   action :delete
end

template '/etc/zabbix/zabbix_server.conf' do
   source 'zabbix_server.conf.erb'
   owner 'root'
   group 'root'
   mode '0644'
end

service 'zabbix-agent' do
  action :start
end

service 'zabbix-server' do
   action :start
end
