if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
if [ -e /home/tony/.nix-profile/etc/profile.d/nix.sh ]; then . /home/tony/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
source "$HOME/.cargo/env"
