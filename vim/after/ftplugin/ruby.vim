setlocal shiftwidth=2
setlocal tabstop=2
setlocal expandtab
compiler ruby
set makeprg=ruby\ -w\ $*\ %
