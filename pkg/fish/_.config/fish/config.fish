set fish_greeting

if type -q mise
  mise activate fish | source
end

fish_add_path "$HOME/bin"
fish_add_path "$HOME/.local/bin"

if test -d /opt/homebrew/bin
  fish_add_path "/opt/homebrew/bin"
end

# pnpm
set -gx PNPM_HOME "/Users/tony/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

if test -f "$HOME/.local/share/mise/installs/gcloud/latest/path.fish.inc"
  source "$HOME/.local/share/mise/installs/gcloud/latest/path.fish.inc"
end
