#!/usr/bin/env bash
# Getfile.sh - Retrieve file from Transfer server
########################################################

main() {

USER="$1";
PWD="$2";

echo "$(date) ${BASH_SOURCE##*/} Retrieving file from transfer server";

cat "Host *" >  ssh_config;
cat "  ForwardAgent no" >> ssh_config;
cat "  ForwardX11 no" >> ssh_config;
cat "  RhostsAuthentication no" >> ssh_config;
cat "  RhostsRSAAuthentication no" >> ssh_config;
cat "  RSAAuthentication no" >> ssh_config;
cat "  PasswordAuthentication yes" >> ssh_config;
cat "  HostbasedAuthentication no" >> ssh_config;
cat "  BatchMode no" >> ssh_config;
cat "  CheckHostIP yes" >> ssh_config;
cat "  AddressFamily any" >> ssh_config;
cat "  ConnectTimeout 0" >> ssh_config;
cat "  StrictHostKeyChecking ask" >> ssh_config;
cat "  IdentityFile ~/.ssh/identity" >> ssh_config;
cat "  IdentityFile ~/.ssh/id_rsa" >> ssh_config;
cat "  IdentityFile ~/.ssh/id_dsa" >> ssh_config;
cat "  Port 22" >> ssh_config;
cat "  Protocol 2,1" >> ssh_config;
cat "Protocol 2" >> ssh_config;
cat "  Cipher 3des" >> ssh_config;
cat "  Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc" >> ssh_config;
cat "  EscapeChar ~" >> ssh_config;

sftp -F ssh_config neil.beesley@ibm.com@w3-transfer.boulder.ibm.com;
exitIfError;

cd www/prot;

ls
}

exitIfError() {

if [ $? != 0 ]
then
    echo "$(date) ${BASH_SOURCE##*/} *** Process terminated: see error message above";
    exit 1;
fi

}

main "$@"