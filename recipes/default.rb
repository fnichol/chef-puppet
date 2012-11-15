apt_repository "puppetlabs" do
  uri           "http://apt.puppetlabs.com/"
  distribution  node['lsb']['codename']
  components    ["main"]
  key           "http://apt.puppetlabs.com/pubkey.gpg"
end

package "puppetmaster"
