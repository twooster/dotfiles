set fish_greeting

if command -s direnv >/dev/null
  eval (direnv hook fish)
end

contains "$HOME/.local/bin" $fish_user_paths; or set -Ua fish_user_paths "$HOME/.local/bin"
contains "$HOME/go/bin" $fish_user_paths; or set -Ua fish_user_paths "$HOME/go/bin"
contains "$HOME/.cargo/bin" $fish_user_paths; or set -Ua fish_user_paths "$HOME/.cargo/bin"
if test (uname) = Darwin
  if test -d /opt/homebrew/bin
    contains /opt/homebrew/bin $fish_user_paths; or set -Ua fish_user_paths /opt/homebrew/bin
  end
  if test -f /opt/homebrew/opt/asdf/libexec/asdf.fish
    source /opt/homebrew/opt/asdf/libexec/asdf.fish
  end
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tony/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/tony/Downloads/google-cloud-sdk/path.fish.inc'; end

# pnpm
set -gx PNPM_HOME "/Users/tony/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
