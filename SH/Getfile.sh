#!/usr/bin/env bash
# Getfile.sh - Retrieve file from Transfer server
########################################################

main() {

USER="$1";
PWD="$2";

echo "$(date) ${BASH_SOURCE##*/} Retrieving file from transfer server";

echo "Host *" >  ssh_config;
echo "  ForwardAgent no" >> ssh_config;
echo "  ForwardX11 no" >> ssh_config;
echo "  RhostsAuthentiechoion no" >> ssh_config;
echo "  RhostsRSAAuthentiechoion no" >> ssh_config;
echo "  RSAAuthentiechoion no" >> ssh_config;
echo "  PasswordAuthentiechoion yes" >> ssh_config;
echo "  HostbasedAuthentiechoion no" >> ssh_config;
echo "  BatchMode no" >> ssh_config;
echo "  CheckHostIP yes" >> ssh_config;
echo "  AddressFamily any" >> ssh_config;
echo "  ConnectTimeout 0" >> ssh_config;
echo "  StrictHostKeyChecking ask" >> ssh_config;
echo "  IdentityFile ~/.ssh/identity" >> ssh_config;
echo "  IdentityFile ~/.ssh/id_rsa" >> ssh_config;
echo "  IdentityFile ~/.ssh/id_dsa" >> ssh_config;
echo "  Port 22" >> ssh_config;
echo "  Protocol 2,1" >> ssh_config;
echo "Protocol 2" >> ssh_config;
echo "  Cipher 3des" >> ssh_config;
echo "  Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc" >> ssh_config;
echo "  EscapeChar ~" >> ssh_config;

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