#
# Cookbook Name:: matt-vim
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'apt'
include_recipe 'git'
include_recipe 'mercurial'
include_recipe 'build-essential::default'

include_recipe 'matt-vim::source'

username = node['matt-vim']['user']
user_home = "/home/#{username}"

# clone from git .vim repo
git "#{user_home}/.vim" do
  repository node['matt-vim']['config_repo']
  checkout_branch 'master'
  revision 'master'
  user username
  group username
  action :sync
  notifies :run, 'execute[install-vim-bundles]', :delayed
end

# add external vimrc
template File.join(user_home, '.vimrc') do
  source 'vimrc.erb'
  user username
  group username
  mode 0644
  action :create_if_missing
end

# this folder isn't tracked by the vim repo, so it needs to be created
directory File.join(user_home, '.vim', 'bundle') do
  owner username
  group username
end

# install vundle
git "#{user_home}/.vim/bundle/Vundle.vim" do
  repository node['matt-vim']['vundle_repo']
  checkout_branch 'master'
  revision 'master'
  user username
  group username
  action :sync
end

execute 'install-vim-bundles' do
  user username
  environment 'HOME' => user_home
  cwd user_home
  command 'vim -c "set shortmess=at" +PluginInstall +qall'
  action :nothing
  notifies :run, 'execute[compile-ycm]', :delayed
end

# compile you complete me if it is installed
ycm_path = "#{user_home}/.vim/bundle/YouCompleteMe"
execute 'compile-ycm' do
  user username
  cwd ycm_path
  command './install.sh'
  only_if { File.exist?(ycm_path) }
  action :nothing
end
