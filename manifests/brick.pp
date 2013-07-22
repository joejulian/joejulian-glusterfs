# == Define: glusterfs::brick
#
# The glusterfs::brick defined resource is responsible for ensuring
# the brick path exists and exporting the brick resource.
#
# === Parameters
#
# $host = $fqdn
#
#   The $host parameter must match the hostname you use for the peer.
#   It can be any valid hostname, though, and defaults to this host's
#   $fqdn.
#
# $rack = undef
#
#    The $rack parameter is reserved for future use. It will be used
#    to add rack-awareness to the brick-order logic.
#
# $order = undef
#
#    The $order parameter may be used to specify a specific brick order.
#
# === Examples
#
#  glusterfs::brick { "/data/gluster/myvol/a/brick": host => $fqdn }
#  glusterfs::brick { "/data/gluster/myvol/b/brick": host => $fqdn }
#  glusterfs::brick { "/data/gluster/myvol/c/brick": host => $fqdn }
#  glusterfs::brick { "/data/gluster/myvol/d/brick": host => $fqdn }
#
# === Authors
#
# Author Name <me@joejulian.name>
#
# === Copyright
#
# Copyright 2013 Joe Julian <me@joejulian.name>
define glusterfs::brick (
  $path = $title,
  $host = $::fqdn,
  $rack = undef,
  $order = undef
) {
  include glusterfs::server

  file { $path:
    ensure => directory,
    owner  => 'root',
    mode   => '0700',
  }

  $logfn =  regsubst($path,'/','-')
  logfile { '/var/log/glusterfs/bricks/${logfn}':
    type => 'glusterfs-brick',
  }

  @@glusterfs_brick {
    $path = $path,
    $host = $host,
    $rack = $rack,
    $order = $order
  }
}

define glusterfs_brick (
  $path = $title,
  $host,
  $rack,
  $order
) { }
