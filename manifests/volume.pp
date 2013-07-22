# == Define: glusterfs::volume
#
# The glusterfs::volume defined resource is responsible for ensuring
# the volume exists and is utilizing all the bricks that are tagged
# for this volume.
#
# === Parameters
#
# $bricktag = undef
#
#   The $bricktag parameter allows specific bricks to be tagged and
#   included in this volume.
#
# $replica = 1
#
#   The $replica parameter specifies the replica count.
#
# $settings = undef
#
#   The $settings parameter is used for volume settings.
#
# $ensure = 'started'
#
#   The $ensure parameter can be 'started', 'stopped', 'absent'.
#
# === Example
#
#  glusterfs::volume { "myvol1":
#    bricktag => 'myvol1',
#    replica  => 2,
#    settings => { 'nfs.enable' => 'no' },
#  }
#
# === Authors
#
# Author Name <me@joejulian.name>
#
# === Copyright
#
# Copyright 2013 Joe Julian <me@joejulian.name>
#
define glusterfs::volume (
  $name = $title,
  $bricktag = undef,
  $replica = 1,
  $settings = undef,
  $ensure = 'started'
) {
  include glusterfs::server

  glusterfs_volume { $name:
    ensure   => $ensure
    bricks   => [ Glusterfs_brick <<| tag == $bricktag |>> ],
    replica  => $replica,
    settings => $settings,
  }
}
