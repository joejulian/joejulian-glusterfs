require 'spec_helper'

describe 'glusterfs' do
  describe 'on debian' do
    let (:facts) { 
      { :operatingsystem => 'Debian',
        :osfamily        => 'Debian', }
    }

    it { expect {subject}.to raise_error(
      Puppet::Error, /Debian is not yet supported./) }
  end

  describe 'on centos' do
    let (:facts) { 
      { :operatingsystem => 'CentOS',
        :osfamily        => 'RedHat', }
    }

    it {
      should include_class('yum::supplemental::gluster_org')
      should include_class('glusterfs::package::base')
    }
  end

  describe 'on fedora < 17' do
    let (:facts) { 
      { :operatingsystem        => 'Fedora',
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '16' }
    }

    it {
      should include_class('yum::supplemental::gluster_org')
      should include_class('glusterfs::package::base')
    }
  end

  describe 'on fedora 17 and 18' do
    let (:facts) { 
      { :operatingsystem        => 'Fedora',
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '17' }
    }

    it {
      should include_class('yum::supplemental::gluster_org')
      should include_class('glusterfs::package::base')
    }
  end

  describe 'on fedora > 18' do
    let (:facts) { 
      { :operatingsystem        => 'Fedora',
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '19' }
    }

    it {
      should include_class('glusterfs::package::base')
    }
  end

  describe 'on Minix' do
    let (:facts) { 
      { :operatingsystem => 'Minix',
        :osfamily        => 'Minix', }
    }

    it { expect {subject}.to raise_error(
      Puppet::Error, /Minix is not yet supported./) }
  end

end
