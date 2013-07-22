require 'spec_helper'

provider_class = Puppet::Type.type(:glusterfs_peer).provider(:glusterfs)

describe provider_class do
  subject { provider_class }

  let(:raw_peers) do
    <<-XML_OUTPUT
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cliOutput>
  <opRet>0</opRet>
  <opErrno>0</opErrno>
  <opErrstr/>
  <peerStatus>
    <peer>
      <uuid>ceed91d5-e8d1-434d-9d47-63e914c93424</uuid>
      <hostname>server2</hostname>
      <connected>1</connected>
      <state>3</state>
      <stateStr>Peer in Cluster</stateStr>
    </peer>
    <peer>
      <uuid>2d85014b-3e4c-4b53-b274-c25d2fa14771</uuid>
      <hostname>server3</hostname>
      <connected>1</connected>
      <state>3</state>
      <stateStr>Peer in Cluster</stateStr>
    </peer>
    <peer>
      <uuid>09366c55-a8b6-4b27-b23b-ee40bb9fd224</uuid>
      <hostname>server4</hostname>
      <connected>1</connected>
      <state>3</state>
      <stateStr>Peer in Cluster</stateStr>
    </peer>
  </peerStatus>
</cliOutput>
XML_OUTPUT
  end

  let(:raw_peers_with) do
    <<-XML_OUTPUT
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cliOutput>
  <opRet>0</opRet>
  <opErrno>0</opErrno>
  <opErrstr/>
  <peerStatus>
    <peer>
      <uuid>ceed91d5-e8d1-434d-9d47-63e914c93424</uuid>
      <hostname>server2</hostname>
      <connected>1</connected>
      <state>3</state>
      <stateStr>Peer in Cluster</stateStr>
    </peer>
    <peer>
      <uuid>2d85014b-3e4c-4b53-b274-c25d2fa14771</uuid>
      <hostname>server3</hostname>
      <connected>1</connected>
      <state>3</state>
      <stateStr>Peer in Cluster</stateStr>
    </peer>
    <peer>
      <uuid>09366c55-a8b6-4b27-b23b-ee40bb9fd224</uuid>
      <hostname>server4</hostname>
      <connected>1</connected>
      <state>3</state>
      <stateStr>Peer in Cluster</stateStr>
    </peer>
    <peer>
      <uuid>32236c55-a8b6-4b27-b23b-ee40bb9cba80</uuid>
      <hostname>server5</hostname>
      <connected>1</connected>
      <state>3</state>
      <stateStr>Peer in Cluster</stateStr>
    </peer>
  </peerStatus>
</cliOutput>
XML_OUTPUT
  end
  let(:parsed_peers) { %w(server2 server3 server4) }

  before :each do
    @resource = Puppet::Type::Glusterfs_peer.new( { :name => 'server5', :tag => 'peergroup1' } )
    @provider = provider_class.new(@resource)
    Puppet::Util.stubs(:which).with('gluster').returns('/usr/sbin/gluster')
    subject.stubs(:which).with('gluser').returns('/usr/sbin/gluster')
  end

  describe 'self.instances' do
    it 'returns an array of peers' do
      subject.stubs(:gluster).with(['gluster','--xml','peer','status']).returns(raw_peers)
      peernames = subject.instances.collect {|x| x.name}
      parsed_peers.should match_array(peernames)
    end
  end

  describe 'create' do
    it 'adds a peer to the trusted pool' do
      subject.expects(:gluster).with(['gluster','peer','probe','server5'])
      @provider.expects(:exists?).returns(true)
      @provider.create.should be_true
    end
  end

  describe 'destroy' do
    it 'removes a peer from the trusted pool' do
      subject.expects(:gluster).with(['gluster','peer','detach','server5'])
      @provider.expects(:exists?).returns(false)
      @provider.destroy.should be_true
    end
  end

  describe 'exists?' do
    it 'checks if peer exists' do
      subject.stubs(:gluster).with(['gluster','--xml','peer','status']).returns(raw_peers)
      @provider.exists?.should be_false
      subject.stubs(:gluster).with(['gluster','--xml','peer','status']).returns(raw_peers_with)
      @provider.exists?.should be_true
    end
  end
end
