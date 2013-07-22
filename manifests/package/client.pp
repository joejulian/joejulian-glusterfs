# comment
class glusterfs::package::client ( $ensure = 'installed' ) {
  case $::osfamily  {
    'redhat': {
      $packagename = 'glusterfs-fuse'
    }
    'debian': {
      $packagename = 'glusterfs-client'
    }
    default : {
      fail('This OS family is not yet supported by this module')
    }
  }
  package { $packagename:
    ensure => $ensure
  }
}
