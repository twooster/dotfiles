noblacklist ~/.config/zoomus.conf

include /etc/firejail/zoom.local
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

whitelist ~/.zoom

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp

private-tmp
