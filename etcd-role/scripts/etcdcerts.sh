ETCD_HOSTNAME=$1
ETCD_IP=$2


#get and build etcd-ca
cd /tmp
git clone https://github.com/coreos/etcd-ca
cd etcd-ca
./build
cp bin/etcd-ca /usr/local/bin
cd /tmp
rm -fr /tmp/etcd-ca
#strip the f'ing newline
/usr/bin/perl -p -i -e 's/\R//g;' /tmp/.etcd-ca/ca.crt.info

#create certificates from the new ca

etcd-ca new-cert --passphrase '' --ip $ETCD_IP --domain $ETCD_HOSTNAME $ETCD_HOSTNAME
etcd-ca sign --passphrase '' $ETCD_HOSTNAME
etcd-ca export --insecure --passphrase '' $ETCD_HOSTNAME | tar xvf -
etcd-ca chain $ETCD_HOSTNAME > /tmp/.etcd-ca/$ETCD_HOSTNAME.ca.crt
cp /tmp/.etcd-ca/${ETCD_HOSTNAME}* /var/etcd_certs


