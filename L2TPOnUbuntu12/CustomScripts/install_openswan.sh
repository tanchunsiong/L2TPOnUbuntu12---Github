# Custom Script for Linux
sudo apt-get install -y xl2tpd ppp

sudo export DEBIAN_FRONTEND=noninteractive

sudo apt-get install -y openswan

ipvariable="`wget -qO- ipinfo.io/ip`"

sudo sh -c "echo 'config setup' > /etc/ipsec.conf"
sudo sh -c "echo '\tnat_traversal=yes' >> /etc/ipsec.conf"
sudo sh -c "echo '\tvirtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12' >> /etc/ipsec.conf"
sudo sh -c "echo '\toe=off' >> /etc/ipsec.conf"
sudo sh -c "echo '\tprotostack=netkey' >> /etc/ipsec.conf"
sudo sh -c "echo '' >> /etc/ipsec.conf"
sudo sh -c "echo 'conn L2TP-PSK-NAT' >> /etc/ipsec.conf"
sudo sh -c "echo '\trightsubnet=vhost:%priv' >> /etc/ipsec.conf"
sudo sh -c "echo '\talso=L2TP-PSK-noNAT' >> /etc/ipsec.conf"
sudo sh -c "echo '' >> /etc/ipsec.conf" 
sudo sh -c "echo 'conn L2TP-PSK-noNAT' >> /etc/ipsec.conf"
sudo sh -c "echo '\tauthby=secret' >> /etc/ipsec.conf"
sudo sh -c "echo '\tpfs=no' >> /etc/ipsec.conf"
sudo sh -c "echo '\tauto=add' >> /etc/ipsec.conf"
sudo sh -c "echo '\tkeyingtries=3' >> /etc/ipsec.conf"
sudo sh -c "echo '\trekey=no' >> /etc/ipsec.conf"
sudo sh -c "echo '\tdpddelay=30' >> /etc/ipsec.conf"
sudo sh -c "echo '\tdpdtimeout=120' >> /etc/ipsec.conf"
sudo sh -c "echo '\tdpdaction=clear' >> /etc/ipsec.conf"
sudo sh -c "echo '\tikelifetime=8h' >> /etc/ipsec.conf"
sudo sh -c "echo '\tkeylife=1h' >> /etc/ipsec.conf"
sudo sh -c "echo '\ttype=transport' >> /etc/ipsec.conf"
sudo sh -c "echo '\tleft=10.0.0.4' >> /etc/ipsec.conf"
sudo sh -c "echo '\tleftprotoport=17/1701' >> /etc/ipsec.conf"
sudo sh -c "echo '\tright=%any' >> /etc/ipsec.conf"
sudo sh -c "echo '\trightprotoport=17/%any' >> /etc/ipsec.conf"
sudo sh -c "echo '\tforceencaps=yes' >> /etc/ipsec.conf"   
sudo sh -c "echo '' >> /etc/ipsec.conf"

sudo sh -c "echo '$ipvariable  %any :  PSK \"$3\"' >> /etc/ipsec.secrets"




# Disable send redirects
sudo sh -c "echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects"
sudo sh -c "echo 0 > /proc/sys/net/ipv4/conf/default/send_redirects"
sudo sh -c "echo 0 > /proc/sys/net/ipv4/conf/eth0/send_redirects"
sudo sh -c "echo 0 > /proc/sys/net/ipv4/conf/lo/send_redirects"

# Disable accept redirects
sudo sh -c "echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects"
sudo sh -c "echo 0 > /proc/sys/net/ipv4/conf/default/accept_redirects"
sudo sh -c "echo 0 > /proc/sys/net/ipv4/conf/eth0/accept_redirects"
sudo sh -c "echo 0 > /proc/sys/net/ipv4/conf/lo/accept_redirects"

#Start the IPSEC service with 
sudo /etc/init.d/ipsec start

#create the file
sudo touch /etc/init.d/ipsec.vpn


sudo sh -c "echo 'case \"\$1\" in' > /etc/init.d/ipsec.vpn"
sudo sh -c "echo '  start)' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'echo \"Starting my Ipsec VPN\"' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'iptables  -t nat   -A POSTROUTING -o eth0 -s 10.0.0.0/24 -j MASQUERADE' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'echo 1 > /proc/sys/net/ipv4/ip_forward' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'for each in /proc/sys/net/ipv4/conf/*' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'do' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '    echo 0 > $each/accept_redirects' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '    echo 0 > $each/send_redirects' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'done' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '/etc/init.d/ipsec start' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '/etc/init.d/xl2tpd start' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo ';;' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'stop)' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'echo \"Stopping my Ipsec VPN\"' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'iptables --table nat --flush' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'echo 0 > /proc/sys/net/ipv4/ip_forward' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '/etc/init.d/ipsec stop' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '/etc/init.d/xl2tpd stop' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo ';;' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'restart)' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'echo \"Restarting my Ipsec VPN\"' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'iptables  -t nat   -A POSTROUTING -o eth0 -s 10.0.0.0/24 -j MASQUERADE' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'echo 1 > /proc/sys/net/ipv4/ip_forward' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'for each in /proc/sys/net/ipv4/conf/*' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'do' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '    echo 0 > $each/accept_redirects' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '    echo 0 > $each/send_redirects' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'done' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '/etc/init.d/ipsec restart' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '/etc/init.d/xl2tpd restart' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo ';;' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '  *)' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo ' echo \"Usage: /etc/init.d/ipsec.vpn  {start|stop|restart}\"' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo ' exit 1' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo '  ;;' >> /etc/init.d/ipsec.vpn"
sudo sh -c "echo 'esac' >> /etc/init.d/ipsec.vpn"

sudo chmod 755 /etc/init.d/ipsec.vpn

#update-rc.d -f ipsec remove

#update-rc.d ipsec.vpn defaults

sudo sh -c "echo '[global]' > /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo 'ipsec saref = no' >> /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo '' >> /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo '[lns default]' >> /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo 'ip range = 10.0.0.5-10.0.0.254' >> /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo 'local ip = 10.0.0.4' >> /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo 'require chap = yes' >> /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo 'refuse pap = yes' >> /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo 'require authentication = yes' >> /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo 'ppp debug = yes' >> /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo 'pppoptfile = /etc/ppp/options.xl2tpd' >> /etc/xl2tpd/xl2tpd.conf"
sudo sh -c "echo 'length bit = yes' >> /etc/xl2tpd/xl2tpd.conf"

sudo sh -c "echo '* * $3' >>  /etc/xl2tpd/l2tp-secrets"

        
sudo touch /etc/ppp/options.xl2tpd

sudo sh -c "echo 'refuse-mschap-v2' > /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'refuse-mschap' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'ms-dns 8.8.8.8' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'ms-dns 8.8.4.4' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'asyncmap 0' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'auth' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'crtscts' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'idle 1800' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'mtu 1200' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'mru 1200' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'lock' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'hide-password' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'local' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo '#debug' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'name l2tpd' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'proxyarp' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'lcp-echo-interval 30' >> /etc/ppp/options.xl2tpd"
sudo sh -c "echo 'lcp-echo-failure 4' >> /etc/ppp/options.xl2tpd"

sudo sh -c "echo 'azureuser l2tpd pass@word123 *' >> /etc/ppp/chap-secrets"
sudo sh -c "echo '$1 l2tpd $2 *' >> /etc/ppp/chap-secrets"

sudo sed -i '/^#.*net.ipv4.ip_forward=1/s/^#//' /etc/sysctl.conf

sudo sysctl -p

sudo /etc/init.d/ipsec.vpn restart
sudo /etc/init.d/xl2tpd restart