export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_GC_HEAP_INIT_SLOTS=${RUBY_HEAP_MIN_SLOTS} # recent Ruby
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=100000000
export RUBY_HEAP_FREE_MIN=500000

alias be='bundle exec'

#if [ -d ~/.local/share/chruby ]; then
#  . ~/.local/share/chruby/chruby.sh
#  . ~/.local/share/chruby/auto.sh
#fi
#
#if [ -d "${HOME}/.rbenv" ]; then
#  PATH="${HOME}/.rbenv/bin:${PATH}"
#  which rbenv > /dev/null && eval "$(rbenv init -)"
#fi
