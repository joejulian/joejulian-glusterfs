# == Class: glusterfs
#
# The glusterfs class is responsible for loading the base packages and
# ensuring the correct repo is installed
#
# === Examples
#
#  class { glusterfs: }
#
# === Authors
#
# Author Name <me@joejulian.name>
#
# === Copyright
#
# Copyright 2013 Joe Julian <me@joejulian.name>
#
class glusterfs {
  case $::operatingsystem {
    debian, ubuntu: {
      # Failing these as the managed apt class has not been written
      fail("${::operatingsystem} is not yet supported.")
      include apt::supplemental::gluster_org
      Class['apt::supplemental::gluster_org'] ->
      Class['glusterfs::package::base']
    }
    centos, rhel: {
      include yum::supplemental::gluster_org
      Class['yum::supplemental::gluster_org'] ->
      Class['glusterfs::package::base']
    }
    fedora: {
      if ( $::operatingsystemrelease < 18 ) {
        include yum::supplemental::gluster_org
        Class['yum::supplemental::gluster_org'] ->
        Class['glusterfs::package::base']
      }
    }
    default: {
      fail("${::operatingsystem} is not yet supported.")
    }
  }
  include glusterfs::package::base
}
