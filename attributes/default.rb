default['zabbix']['Server'] = '192.168.103.242'
default['zabbix']['ServerActive'] = '192.168.103.242'

default['zabbix_server']['DebugLevel'] = '4'
default['zabbix_server']['DBName'] = 'zabbix'
default['zabbix_server']['DBUser'] = 'admin'
default['zabbix_server']['DBPassword'] = '342112f'
default['zabbix_server']['JavaGateway'] = '0.0.0.0'
default['zabbix_server']['JavaGatewayPort'] = '10052'
default['zabbix_server']['StartJavaPollers'] = '5'
default['zabbix_server']['TimeOut'] = '30'
# For Mysql

node.default['mysql']['DBUser'] = 'root'
node.default['mysql']['DBPassword'] = '342112f'
node.default['mysql']['DBName'] = 'zabbix'
node.default['mysql']['zabbix_server']['DBUser'] = 'admin@localhost'
node.default['mysql']['zabbix_server']['DBPassword'] = '342112f'
