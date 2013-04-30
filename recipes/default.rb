#
# Cookbook Name:: play
# Recipe:: default
#
# Copyright 2013, CodeInside
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
#

execute "apt-get" do
  command "apt-get update"
end

dependencies = %w{unzip}
dependencies.each do |pkg|
  apt_package pkg do
    action :install
  end
end

bash "download_playframework" do
user "root"
cwd node[:play_framework][:tmp_dir]
code <<-EOH
wget -c #{node[:play_framework][:url]} -O #{node[:play_framework][:filename]}
mkdir #{node[:play_framework][:install_dir]}
unzip #{node[:play_framework][:filename]} -d #{node[:play_framework][:install_dir]}
chown -R vagrant:vagrant #{node[:play_framework][:install_dir]}
EOH
end

bash "set-env" do
	user "root"
	cwd node[:play_framework][:install_dir]
code <<-EOH
echo "export PATH=$PATH:#{node[:play_framework][:set_env_path]}" > /etc/profile.d/play.sh
EOH
end