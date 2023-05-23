			Домашнее задание 5.1

Создание автоматизированного Vagrantfile 


1. Подготавливаем vagrantfile

```

# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
 config.vm.box = "centos/7"
 config.vm.box_version = "2004.01"
 config.vm.provider "virtualbox" do |v|
 v.memory = 256
 v.cpus = 1
 end
 config.vm.define "nfss" do |nfss|
 nfss.vm.network "private_network", ip: "192.168.56.101",  virtualbox__intnet: "net1"
 nfss.vm.hostname = "nfss"
 config.vm.provision "shell", path: "nfss_script.sh"
 end
 config.vm.define "nfsc" do |nfsc|
 nfsc.vm.network "private_network", ip: "192.168.56.11",  virtualbox__intnet: "net1"
 nfsc.vm.hostname = "nfsc"
 config.vm.provision "shell", path: "nfsc_script.sh"
 end
end

```

2. Создаем 2 bash-скрипта, `nfss_script.sh` - для конфигурирования сервера и `nfsc_script.sh` - для конфигурирования клиента, в которых описываем bash-командами ранее выполненные шаги

```

`nfss_script.sh`

sudo -i
bash
yum install nfs-utils -y
systemctl enable firewalld --now
firewall-cmd --add-service="nfs3" \
--add-service="rpc-bind" \
--add-service="mountd" \
--permanent
firewall-cmd --reload
systemctl enable nfs --now
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
chmod 0777 /srv/share/upload
cat << EOF > /etc/exports
/srv/share 192.168.56.11/32(rw,sync,root_squash)
EOF
exportfs -r

```

```

`nfsc_script.sh`


sudo -i

bash

yum install nfs-utils -y
echo "192.168.56.101:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
systemctl daemon-reload
systemctl restart remote-fs.target

```

3. После того, как вы опишете конфигурацию для автоматизированного развёртывания, 
   уничтожьте тестовый стенд командой `vagrant destory  -f`. выполните все пункты из
    __[Проверка работоспособности](#Проверка-работоспособности)

```

user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$ vagrant destroy -f
==> nfsc: Forcing shutdown of VM...
==> nfsc: Destroying VM and associated drives...
==> nfss: Forcing shutdown of VM...
==> nfss: Destroying VM and associated drives...
user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$
user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$
user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$
user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$ vagrant up
Bringing machine 'nfss' up with 'virtualbox' provider...
Bringing machine 'nfsc' up with 'virtualbox' provider...
==> nfss: Importing base box 'centos/7'...
==> nfss: Matching MAC address for NAT networking...
==> nfss: Checking if box 'centos/7' version '2004.01' is up to date...
==> nfss: Setting the name of the VM: DZ-51_nfss_1684854759885_45048
==> nfss: Clearing any previously set network interfaces...
==> nfss: Preparing network interfaces based on configuration...
    nfss: Adapter 1: nat
    nfss: Adapter 2: intnet
==> nfss: Forwarding ports...
    nfss: 22 (guest) => 2222 (host) (adapter 1)
==> nfss: Running 'pre-boot' VM customizations...
==> nfss: Booting VM...
==> nfss: Waiting for machine to boot. This may take a few minutes...
    nfss: SSH address: 127.0.0.1:2222
    nfss: SSH username: vagrant
    nfss: SSH auth method: private key
    nfss:
    nfss: Vagrant insecure key detected. Vagrant will automatically replace
    nfss: this with a newly generated keypair for better security.
    nfss:
    nfss: Inserting generated public key within guest...
    nfss: Removing insecure key from the guest if it's present...
    nfss: Key inserted! Disconnecting and reconnecting using new SSH key...
==> nfss: Machine booted and ready!
==> nfss: Checking for guest additions in VM...
    nfss: No guest additions were detected on the base box for this VM! Guest
    nfss: additions are required for forwarded ports, shared folders, host only
    nfss: networking, and more. If SSH fails on this machine, please install
    nfss: the guest additions and repackage the box to continue.
    nfss:
    nfss: This is not an error message; everything may continue to work properly,
    nfss: in which case you may ignore this message.
==> nfss: Setting hostname...
==> nfss: Configuring and enabling network interfaces...
==> nfss: Rsyncing folder: /home/user/DZ-OTUS/DZ-5.1/ => /vagrant
==> nfss: Running provisioner: shell...
    nfss: Running: /tmp/vagrant-shell20230523-74224-1adarp7.sh
    nfss: Loaded plugins: fastestmirror
    nfss: Determining fastest mirrors
    nfss:  * base: ftp.uni-bayreuth.de
    nfss:  * extras: centos.bio.lmu.de
    nfss:  * updates: mirror.imt-systems.com
    nfss: Resolving Dependencies
    nfss: --> Running transaction check
    nfss: ---> Package nfs-utils.x86_64 1:1.3.0-0.66.el7 will be updated
    nfss: ---> Package nfs-utils.x86_64 1:1.3.0-0.68.el7.2 will be an update
    nfss: --> Finished Dependency Resolution
    nfss:
    nfss: Dependencies Resolved
    nfss:
    nfss: ================================================================================
    nfss:  Package          Arch          Version                    Repository      Size
    nfss: ================================================================================
    nfss: Updating:
    nfss:  nfs-utils        x86_64        1:1.3.0-0.68.el7.2         updates        413 k
    nfss:
    nfss: Transaction Summary
    nfss: ================================================================================
    nfss: Upgrade  1 Package
    nfss:
    nfss: Total download size: 413 k
    nfss: Downloading packages:
    nfss: No Presto metadata available for updates
    nfss: Public key for nfs-utils-1.3.0-0.68.el7.2.x86_64.rpm is not installed
    nfss: warning: /var/cache/yum/x86_64/7/updates/packages/nfs-utils-1.3.0-0.68.el7.2.x86_64.rpm: Header V3 RSA                          /SHA256 Signature, key ID f4a80eb5: NOKEY
    nfss: Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    nfss: Importing GPG key 0xF4A80EB5:
    nfss:  Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
    nfss:  Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
    nfss:  Package    : centos-release-7-8.2003.0.el7.centos.x86_64 (@anaconda)
    nfss:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    nfss: Running transaction check
    nfss: Running transaction test
    nfss: Transaction test succeeded
    nfss: Running transaction
    nfss:   Updating   : 1:nfs-utils-1.3.0-0.68.el7.2.x86_64                          1/2
    nfss:   Cleanup    : 1:nfs-utils-1.3.0-0.66.el7.x86_64                            2/2
    nfss:   Verifying  : 1:nfs-utils-1.3.0-0.68.el7.2.x86_64                          1/2
    nfss:   Verifying  : 1:nfs-utils-1.3.0-0.66.el7.x86_64                            2/2
    nfss:
    nfss: Updated:
    nfss:   nfs-utils.x86_64 1:1.3.0-0.68.el7.2
    nfss:
    nfss: Complete!
    nfss: Created symlink from /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service to /usr/lib/systemd                          /system/firewalld.service.
    nfss: Created symlink from /etc/systemd/system/multi-user.target.wants/firewalld.service to /usr/lib/systemd                          /system/firewalld.service.
    nfss: success
    nfss: success
    nfss: Created symlink from /etc/systemd/system/multi-user.target.wants/nfs-server.service to /usr/lib/system                          d/system/nfs-server.service.
==> nfss: Running provisioner: shell...
    nfss: Running: /tmp/vagrant-shell20230523-74224-1qqwk03.sh
    nfss: Loaded plugins: fastestmirror
    nfss: Loading mirror speeds from cached hostfile
    nfss:  * base: ftp.uni-bayreuth.de
    nfss:  * extras: centos.bio.lmu.de
    nfss:  * updates: mirror.imt-systems.com
    nfss: Package 1:nfs-utils-1.3.0-0.68.el7.2.x86_64 already installed and latest version
    nfss: Nothing to do
==> nfsc: Importing base box 'centos/7'...
==> nfsc: Matching MAC address for NAT networking...
==> nfsc: Checking if box 'centos/7' version '2004.01' is up to date...
==> nfsc: Setting the name of the VM: DZ-51_nfsc_1684854839332_2537
==> nfsc: Fixed port collision for 22 => 2222. Now on port 2200.
==> nfsc: Clearing any previously set network interfaces...
==> nfsc: Preparing network interfaces based on configuration...
    nfsc: Adapter 1: nat
    nfsc: Adapter 2: intnet
==> nfsc: Forwarding ports...
    nfsc: 22 (guest) => 2200 (host) (adapter 1)
==> nfsc: Running 'pre-boot' VM customizations...
==> nfsc: Booting VM...
==> nfsc: Waiting for machine to boot. This may take a few minutes...
    nfsc: SSH address: 127.0.0.1:2200
    nfsc: SSH username: vagrant
    nfsc: SSH auth method: private key
    nfsc:
    nfsc: Vagrant insecure key detected. Vagrant will automatically replace
    nfsc: this with a newly generated keypair for better security.
    nfsc:
    nfsc: Inserting generated public key within guest...
    nfsc: Removing insecure key from the guest if it's present...
    nfsc: Key inserted! Disconnecting and reconnecting using new SSH key...
==> nfsc: Machine booted and ready!
==> nfsc: Checking for guest additions in VM...
    nfsc: No guest additions were detected on the base box for this VM! Guest
    nfsc: additions are required for forwarded ports, shared folders, host only
    nfsc: networking, and more. If SSH fails on this machine, please install
    nfsc: the guest additions and repackage the box to continue.
    nfsc:
    nfsc: This is not an error message; everything may continue to work properly,
    nfsc: in which case you may ignore this message.
==> nfsc: Setting hostname...
==> nfsc: Configuring and enabling network interfaces...
==> nfsc: Rsyncing folder: /home/user/DZ-OTUS/DZ-5.1/ => /vagrant
==> nfsc: Running provisioner: shell...
    nfsc: Running: /tmp/vagrant-shell20230523-74224-vhcfse.sh
    nfsc: Loaded plugins: fastestmirror
    nfsc: Determining fastest mirrors
    nfsc:  * base: mirror.rackspeed.de
    nfsc:  * extras: mirror.eu.oneandone.net
    nfsc:  * updates: mirror.imt-systems.com
    nfsc: Resolving Dependencies
    nfsc: --> Running transaction check
    nfsc: ---> Package nfs-utils.x86_64 1:1.3.0-0.66.el7 will be updated
    nfsc: ---> Package nfs-utils.x86_64 1:1.3.0-0.68.el7.2 will be an update
    nfsc: --> Finished Dependency Resolution
    nfsc:
    nfsc: Dependencies Resolved
    nfsc:
    nfsc: ================================================================================
    nfsc:  Package          Arch          Version                    Repository      Size
    nfsc: ================================================================================
    nfsc: Updating:
    nfsc:  nfs-utils        x86_64        1:1.3.0-0.68.el7.2         updates        413 k
    nfsc:
    nfsc: Transaction Summary
    nfsc: ================================================================================
    nfsc: Upgrade  1 Package
    nfsc:
    nfsc: Total download size: 413 k
    nfsc: Downloading packages:
    nfsc: No Presto metadata available for updates
    nfsc: Public key for nfs-utils-1.3.0-0.68.el7.2.x86_64.rpm is not installed
    nfsc: warning: /var/cache/yum/x86_64/7/updates/packages/nfs-utils-1.3.0-0.68.el7.2.x86_64.rpm: Header V3 RSA                          /SHA256 Signature, key ID f4a80eb5: NOKEY
    nfsc: Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    nfsc: Importing GPG key 0xF4A80EB5:
    nfsc:  Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
    nfsc:  Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
    nfsc:  Package    : centos-release-7-8.2003.0.el7.centos.x86_64 (@anaconda)
    nfsc:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    nfsc: Running transaction check
    nfsc: Running transaction test
    nfsc: Transaction test succeeded
    nfsc: Running transaction
    nfsc:   Updating   : 1:nfs-utils-1.3.0-0.68.el7.2.x86_64                          1/2
    nfsc:   Cleanup    : 1:nfs-utils-1.3.0-0.66.el7.x86_64                            2/2
    nfsc:   Verifying  : 1:nfs-utils-1.3.0-0.68.el7.2.x86_64                          1/2
    nfsc:   Verifying  : 1:nfs-utils-1.3.0-0.66.el7.x86_64                            2/2
    nfsc:
    nfsc: Updated:
    nfsc:   nfs-utils.x86_64 1:1.3.0-0.68.el7.2
    nfsc:
    nfsc: Complete!
    nfsc: Created symlink from /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service to /usr/lib/systemd                          /system/firewalld.service.
    nfsc: Created symlink from /etc/systemd/system/multi-user.target.wants/firewalld.service to /usr/lib/systemd                          /system/firewalld.service.
    nfsc: success
    nfsc: success
    nfsc: Created symlink from /etc/systemd/system/multi-user.target.wants/nfs-server.service to /usr/lib/system                          d/system/nfs-server.service.
==> nfsc: Running provisioner: shell...
    nfsc: Running: /tmp/vagrant-shell20230523-74224-k9q110.sh
    nfsc: Loaded plugins: fastestmirror
    nfsc: Loading mirror speeds from cached hostfile
    nfsc:  * base: mirror.rackspeed.de
    nfsc:  * extras: mirror.eu.oneandone.net
    nfsc:  * updates: mirror.imt-systems.com
    nfsc: Package 1:nfs-utils-1.3.0-0.68.el7.2.x86_64 already installed and latest version
    nfsc: Nothing to do
user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$ vagrant ssh nfss
[vagrant@nfss ~]$ exit
logout
user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$ vagrant ssh nfsc

[vagrant@nfsc ~]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Thu Apr 30 22:04:55 2020
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=1c419d6c-5064-4a2b-953c-05b2c67edb15 /                       xfs     defaults        0 0
/swapfile none swap defaults 0 0
#VAGRANT-BEGIN
# The contents below are automatically generated by Vagrant. Do not modify.
#VAGRANT-END
192.168.56.101:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0

[vagrant@nfsc ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        111M     0  111M   0% /dev
tmpfs           118M     0  118M   0% /dev/shm
tmpfs           118M  4.5M  114M   4% /run
tmpfs           118M     0  118M   0% /sys/fs/cgroup
/dev/sda1        40G  3.2G   37G   8% /
tmpfs            24M     0   24M   0% /run/user/1000

[vagrant@nfsc ~]$ cd /mnt/upload/
[vagrant@nfsc upload]$ ls
[vagrant@nfsc upload]$ mount | grep mnt
systemd-1 on /mnt type autofs (rw,relatime,fd=24,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=28600)
192.168.56.101:/srv/share/ on /mnt type nfs (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=ud                          p,timeo=11,retrans=3,sec=sys,mountaddr=192.168.56.101,mountvers=3,mountport=20048,mountproto=udp,local_lock=none                          ,addr=192.168.56.101)
[vagrant@nfsc upload]$ exit
logout
user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$ vagrant ssh nfss
Last login: Tue May 23 15:21:08 2023 from 10.0.2.2

[vagrant@nfss ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        111M     0  111M   0% /dev
tmpfs           118M     0  118M   0% /dev/shm
tmpfs           118M  4.5M  114M   4% /run
tmpfs           118M     0  118M   0% /sys/fs/cgroup
/dev/sda1        40G  3.2G   37G   8% /
tmpfs            24M     0   24M   0% /run/user/1000
[vagrant@nfss ~]$
[vagrant@nfss ~]$ cd /srv/share/upload/
[vagrant@nfss upload]$ ls

[vagrant@nfss upload]$ touch test-dz-1
[vagrant@nfss upload]$ exit
logout
user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$ vagrant ssh nfsc
Last login: Tue May 23 15:22:04 2023 from 10.0.2.2
[vagrant@nfsc ~]$ cd /mnt/upload/
[vagrant@nfsc upload]$ ls
test-dz-1

user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$ vagrant ssh nfsc
Last login: Tue May 23 15:26:19 2023 from 10.0.2.2
[vagrant@nfsc ~]$ cd /mnt/upload/
[vagrant@nfsc upload]$ touch complited
[vagrant@nfsc upload]$ exit
logout
user@ubuntu-vm:~/DZ-OTUS/DZ-5.1$ vagrant ssh nfss
Last login: Tue May 23 15:37:28 2023 from 10.0.2.2
[vagrant@nfss ~]$ cd /srv/share/upload/
[vagrant@nfss upload]$ ls
!  complitedcd  test-dz-1
[vagrant@nfss upload]$


```




# dz-5.1
