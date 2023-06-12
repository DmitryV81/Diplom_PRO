# -*- mode: ruby -*-
# vim: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  config.vm.provider "virtualbox" 

  config.vm.define "frontend" do |front|
    front.vm.network "private_network", ip: "192.168.50.10"
#    front.vm.network "public_network", ip: "192.168.50.10"
    front.vm.network "forwarded_port", guest:443, host:8443
#    front.vm.network "forwarded_port", guest:80, host:8080
    front.vm.hostname = "frontend"
    front.vm.provider "virtualbox" do |f|
      f.memory = 1024
      f.cpus = 1
    end
  end
  
  config.vm.define "phpfpm" do |pf|
    pf.vm.network "private_network", ip: "192.168.50.25"
    pf.vm.hostname = "phpfpm"
    pf.vm.provider "virtualbox" do |p|
      p.memory = 1024
      p.cpus = 1
    end
  end
  
  config.vm.define "backend1" do |back1|
#    back1.vm.network "private_network", ip: "192.168.255.1", netmask: "255.255.255.252", virtualbox__intnet: "cluster_net"
    back1.vm.network "private_network", ip: "192.168.50.11"
    back1.vm.network "forwarded_port", guest:8080, host:8083
    back1.vm.hostname = "backend1"
    back1.vm.provider "virtualbox" do |b1|
      b1.memory = 1024
      b1.cpus = 1
    end
  end  

  config.vm.define "backend2" do |back2|
#    back2.vm.network "private_network", ip: "192.168.255.2", netmask: "255.255.255.252", virtualbox__intnet: "cluster_net"
    back2.vm.network "private_network", ip: "192.168.50.12"
    back2.vm.network "forwarded_port", guest:8080, host:8084
    back2.vm.hostname = "backend2"
    back2.vm.provider "virtualbox" do |b2|
      b2.memory = 1024
      b2.cpus = 1
    end
  end
  
  config.vm.define "storage1" do |stor1|
#    back1.vm.network "private_network", ip: "192.168.255.1", netmask: "255.255.255.252", virtualbox__intnet: "cluster_net"
    stor1.vm.network "private_network", ip: "192.168.50.20"
    stor1.vm.hostname = "storage1"
    stor1.vm.provider "virtualbox" do |s1|
      unless File.exist?('./storage/cluster.vdi')
            s1.customize ['createhd', '--filename', './storage/cluster.vdi', '--variant', 'Fixed', '--size', 2176]
            needsController = true
      end
      s1.customize ["storagectl", :id, "--name", "SATA", "--add", "sata"]
      s1.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', './storage/cluster.vdi']
      s1.memory = 1024
      s1.cpus = 1
    end
  end
  
  config.vm.define "storage2" do |stor2|
#    back2.vm.network "private_network", ip: "192.168.255.2", netmask: "255.255.255.252", virtualbox__intnet: "cluster_net"
    stor2.vm.network "private_network", ip: "192.168.50.21"
    stor2.vm.hostname = "storage2"
    stor2.vm.provider "virtualbox" do |s2|
      unless File.exist?('./storage/cluster2.vdi')
            s2.customize ['createhd', '--filename', './storage/cluster2.vdi', '--variant', 'Fixed', '--size', 2176]
            needsController = true
      end
      s2.customize ["storagectl", :id, "--name", "SATA", "--add", "sata"]
      s2.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', './storage/cluster2.vdi']
      s2.memory = 1024
      s2.cpus = 1
    end
  end

  config.vm.define "storage3" do |stor3|
#    back2.vm.network "private_network", ip: "192.168.255.2", netmask: "255.255.255.252", virtualbox__intnet: "cluster_net"
    stor3.vm.network "private_network", ip: "192.168.50.22"
    stor3.vm.hostname = "storage3"
    stor3.vm.provider "virtualbox" do |s3|
      unless File.exist?('./storage/cluster3.vdi')
            s3.customize ['createhd', '--filename', './storage/cluster3.vdi', '--variant', 'Fixed', '--size', 2176]
            needsController = true
      end
      s3.customize ["storagectl", :id, "--name", "SATA", "--add", "sata"]
      s3.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', './storage/cluster3.vdi']
      s3.memory = 1024
      s3.cpus = 1
    end
  end
  
  config.vm.define "mysqlmaster" do |master|
#    master.vm.network "private_network", ip: "192.168.255.5", netmask: "255.255.255.252", virtualbox__intnet: "repl_net"
    master.vm.network "private_network", ip: "192.168.50.13"
    master.vm.hostname = "mysqlmaster"
    master.vm.provider "virtualbox" do |m|
      m.memory = 2048
      m.cpus = 1
    end
  end
  
  config.vm.define "mysqlslave" do |slave|
#    slave.vm.network "private_network", ip: "192.168.255.6", netmask: "255.255.255.252", virtualbox__intnet: "repl_net"
    slave.vm.network "private_network", ip: "192.168.50.14"
    slave.vm.hostname = "mysqlslave"
    slave.vm.provider "virtualbox" do |s|
      s.memory = 2048
      s.cpus = 1
    end
  end
  
  config.vm.define "prometheus" do |prometheus|
    prometheus.vm.network "private_network", ip: "192.168.50.15"
    prometheus.vm.network "forwarded_port", guest:9090, host:9090
    prometheus.vm.network "forwarded_port", guest:3000, host:3000
    prometheus.vm.hostname = "prometheus"
    prometheus.vm.provider "virtualbox" do |p|
      p.memory = 4096
      p.cpus = 2
    end
  end  

#  config.vm.define "elk" do |elk|
#    elk.vm.network "private_network", ip: "192.168.50.16", virtualbox__intnet: "net1"
#    elk.vm.network "forwarded_port", guest:9200, host:9200
#    elk.vm.network "forwarded_port", guest:5601, host:5601
#    elk.vm.network "forwarded_port", guest:5000, host:5000    
#    elk.vm.hostname = "elk"
#    elk.vm.provider "virtualbox" do |e|
#      e.memory = 4096
#      e.cpus = 2
#    end
#  end   

end
