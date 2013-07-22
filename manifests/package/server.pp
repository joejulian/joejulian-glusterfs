# comment
class glusterfs::package::server ( $ensure = 'installed' ) {
  package { 'glusterfs-server':
    ensure => $ensure
  }
}
