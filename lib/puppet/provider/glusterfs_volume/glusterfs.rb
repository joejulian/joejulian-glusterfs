require 'xmlsimple'
require 'tempfile'

Puppet::Type.type(:glusterfs_volume).provide(:glusterfs) do
  desc 'Manage a GlusterFS volume'

  defaultfor :kernel => 'Linux'

  commands :gluster => 'gluster'

  def self.instances
    XmlSimple.xml_in(
      gluster(['gluster','--xml','volume','info'])
    )['volInfo'][0]['volumes'].collect { |p| 
      new(:name => p['name'][0])
      new(:status => p['status'][0].to_i)
      new(:replica => p['replicaCount'][0].to_i)
      new(:transport => p['transport'][0].to_i)
    }
  end

  def create
    tempfile = Dir::Tmpname.create('/tmp/joejulian-glusterfs') {|path| path}
    # parse the bricks into a create command
    # use a template to create the cli commands
    # do the cli command
    gluster(['gluster','--mode=script','probe',@resource[:name]],
            { :stdinfile => tempfile )
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
