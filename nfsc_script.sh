sudo -i

bash

yum install nfs-utils -y
echo "192.168.56.101:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
systemctl daemon-reload 
systemctl restart remote-fs.target 

