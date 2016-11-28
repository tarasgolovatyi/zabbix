#
# Copyright 2016, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'serverspec'
set :backend, :exec

describe file ('/etc/yum.repos.d/zabbix.repo') do
  it { should be_file }
end

describe file ('/etc/yum.repos.d/mysql-community-source.repo') do
  it { should be_file }
end

describe file ('/etc/yum.repos.d/mysql-community.repo') do
  it { should be_file }
end

describe file('/etc/zabbix/zabbix_agentd.conf') do
  it { should be_file }
  it { should exist }
end
describe file('/etc/zabbix/zabbix_agentd.conf') do
  its(:content) { should match /Server=192.168.103.242/ }
  its(:content) { should match /ServerActive=192.168.103.242/ }
end

describe file('/etc/zabbix/zabbix_agentd.conf') do
  it { should be_owned_by 'zabbix' }
  it { should be_grouped_into 'zabbix' }
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  it { should be_readable.by_user('zabbix') }
  it { should be_writable.by('owner') }
end

describe service('zabbix-agent') do
  it { should be_running }
end
