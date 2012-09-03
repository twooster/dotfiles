#-------------------------------------------------------------------------------
# DIRCOLORS
#-------------------------------------------------------------------------------

[ -n "$( type -P gdircolors dircolors | head -1 )" ] && {
    COLORS=/etc/DIR_COLORS
    [ -r "/etc/DIR_COLORS.$TERM" ] && COLORS="/etc/DIR_COLORS.$TERM"
    [ -r "$HOME/.dircolors"      ] && COLORS="$HOME/.dircolors"
    [ ! -r "$COLORS"             ] && COLORS=
}
