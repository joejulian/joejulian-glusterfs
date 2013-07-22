# This has to be a separate type to allow collecting
Puppet::Type.newtype(:glusterfs_peer) do
  @doc = "Create a peer group."

  ensurable

  newparam(:name, :namevar=>true) do
    desc "The hostname with which to identify this peer."
  end
end
