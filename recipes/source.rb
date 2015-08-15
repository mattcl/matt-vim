#
# Cookbook Name:: matt-vim
# Recipe:: source
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
node['matt-vim']['source']['dependencies'].each do |dependency|
  package dependency do
    action :install
  end
end

mercurial '/tmp/vim' do
  repository 'https://vim.googlecode.com/hg/'
  action :sync
  notifies :run, 'execute[compile-vim]', :immediately
end

execute 'compile-vim' do
  command "cd /tmp/vim && ./configure #{node['matt-vim']['source']['configuration']} \ && make -j 3 && sudo make install" # rubocop:disable Metrics/LineLength
  action :nothing
end
