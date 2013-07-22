require 'xmlsimple'

Puppet::Type.type(:glusterfs_peer).provide(:glusterfs) do
  desc 'Manage a trust group of associated glusterfs peers'

  defaultfor :kernel => 'Linux'

  commands :gluster => 'gluster'

  def self.instances
    XmlSimple.xml_in(
      gluster(['gluster','--xml','peer','status'])
    )['peerStatus'][0]['peer'].collect { |p| 
      new(:name => p['hostname'][0])
    }
  end

  def create
    gluster(['gluster','peer','probe',@resource[:name]])
    exists? ? (return true) : (return false)
  end

  def destroy
    gluster(['gluster','peer','detach',@resource[:name]])
    exists? ? (return false) : (return true)
  end

  def exists?
    hosts = XmlSimple.xml_in(
      gluster(['gluster','--xml','peer','status'])
    )['peerStatus'][0]['peer'].collect { |p| 
      p['hostname'][0]
    }
    hosts.include?(@resource[:name])
  end
end
