default['matt-vim']['source']['dependencies'] = %w(
  python python2.7-dev libncurses5-dev libperl-dev exuberant-ctags gcc make
  libx11-dev libxt-dev cmake ruby-dev
)

default['matt-vim']['source']['configuration'] = ' --prefix=/usr/local --with-features=huge --enable-rubyinterp --enable-perlinterp --enable-pythoninterp --enable-luainterp --enable-tclinterp --enable-cscope --enable-fontset --enable-multibyte --enable-largefile' # rubocop:disable Metrics/LineLength
