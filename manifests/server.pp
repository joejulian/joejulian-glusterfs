# == Class: glusterfs::server
#
# The glusterfs::brick defined resource is responsible for ensuring
# the brick path exists and exporting the brick resource.
#
# === Parameters
#
# $ensure = 'running'
#
#   The $ensure parameter can be 'running' or 'stopped'
#
# $enable = true
#
#    The $enable parameter is used to enable or disable the server at 
#    boot.
#
# $order = undef
#
#    The $order parameter may be used to specify a specific brick order.
#
# === Examples
#
# This class is not intended to be used directly. Use hiera to override
# these parameters. For instance in yaml:
#
#   glusterfs::server::ensure: stopped
#   glusterfs::server::enable: false
#
# === Authors
#
# Author Name <me@joejulian.name>
#
# === Copyright
#
# Copyright 2013 Joe Julian <me@joejulian.name>
#
class glusterfs::server (
  $ensure = running,
  $enable = true,
) {
  include gluster::package::server

  service { 'glusterd':
    ensure => $ensure,
    enable => $enable,
  }

  logfile { '/var/log/glusterfs/etc-glusterfs-glusterd.vol.log':
    type => 'glusterfs',
  }

  nagios::target::nrpeservicecheck {
    'glusterd' :
      description => 'Gluster Management Daemon',
      command     => 'check_procs -C glusterd -c 1:1',
  }
}
