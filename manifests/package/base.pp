# comment
class glusterfs::package::base ( $ensure = 'installed' ) {
  package { 'glusterfs':
    ensure => $ensure
  }
}
