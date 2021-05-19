Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  # config.vm.provider "virtualbox" do |v|
  #  v.gui = true
  # end

  config.vm.provision "file", source: ".", destination: "$HOME/dotfiles"
end
