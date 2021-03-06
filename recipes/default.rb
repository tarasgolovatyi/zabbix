#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
remote_directory "/home/" do
   files_mode '0644'
   files_owner 'root'
   files_group 'root'
   source "db_rpm"
end

package 'httpd' do
   action :install
end

package 'httpd-devel' do
   action :install
end

rpm_package 'mysql' do 
   source '/home/mysql-server.noarch.rpm'
end

yum_package 'mysql' do
   action :install
end

yum_package 'mysql-server' do
   action :install
end

service 'mysqld' do
   action :start
end

package 'php-mysql' do
   action :install
end

yum_package 'php-pear' do
   action :install
end

bash 'set mysql' do
  action :run
  user 'root'
  cwd "/tmp"
  code <<-EOH
    sudo mysql --execute="SET PASSWORD FOR '#{node['mysql']['DBUser']}'@'localhost' = PASSWORD('#{node['mysql']['DBPassword']}');"
    mysql -u #{node['mysql']['DBUser']} -p#{node['mysql']['DBPassword']} --execute="CREATE DATABASE #{node['mysql']['DBName']} CHARACTER SET UTF8; GRANT ALL PRIVILEGES on #{node['mysql']['DBName']}.* to #{node['mysql']['zabbix_server']['DBUser']} IDENTIFIED BY '#{node['mysql']['zabbix_server']['DBPassword']}'; FLUSH PRIVILEGES;"
    mysql -u #{node['zabbix_server']['DBUser']} -p#{node['mysql']['zabbix_server']['DBPassword']} #{node['zabbix_server']['DBName']} < /home/schema.sql
    mysql -u #{node['zabbix_server']['DBUser']} -p#{node['mysql']['zabbix_server']['DBPassword']} #{node['zabbix_server']['DBName']} < /home/data.sql
    mysql -u #{node['zabbix_server']['DBUser']} -p#{node['mysql']['zabbix_server']['DBPassword']} #{node['zabbix_server']['DBName']} < /home/images.sql
  EOH
end

rpm_package 'zabbix' do
  source '/home/zabbix-3.2.noarch.rpm'
end

package 'zabbix-agent' do 
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
   owner 'zabbix'
   group 'zabbix'
   mode '0644'
end

file '/etc/zabbix/zabbix_java-gateway.conf' do
   action :delete
end

template '/etc/zabbix/zabbix_java_gateway.conf' do
   source 'zabbix_java_gateway.conf.erb'
   owner 'zabbix'
   group 'zabbix'
   mode '0644'
end

file '/etc/zabbix/zabbix_server.conf' do
   action :delete
end

template '/etc/zabbix/zabbix_server.conf' do
   source 'zabbix_server.conf.erb'
   owner 'zabbix'
   group 'zabbix'
   mode '0644'
end

service 'zabbix-agent' do
  action :start
end

service 'zabbix-server' do
   action :start
end

file ['/home/data.sql', '/home/images.sql', '/home/schema.sql', '/home/mysql-server.noarch.rpm', '/home/zabbix-3.2.noarch.rpm'] do
   action :delete
end
