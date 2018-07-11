#!/bin/bash

sudo apt-get install -y build-essential libltdl3-dev
if [ ! -d ~/git/src/github.com/hyperledger ]; then
	mkdir -p ~/git/src/github.com/hyperledger
	cd ~/git/src/github.com/hyperledger/
	git clone -b v1.1.0 https://gerrit.hyperledger.org/r/fabric
else
	echo 'fabric already in place'
fi

if [[ -z "${GOPATH}" ]]; then
	cd /tmp
	wget --no-check-certificate https://storage.googleapis.com/golang/go1.9.3.linux-s390x.tar.gz
	tar -xvf go1.9.3.linux-s390x.tar.gz
	sudo mv -iv go /opt
	cd ~
	cp -ipv .bashrc .bashrc_orig
	echo '' >> .bashrc
	echo "export GOPATH=/home/$USER/git" >> .bashrc
	echo export GOROOT=/opt/go >> .bashrc
	echo "export PATH=/opt/go/bin:/home/$USER/bin:\$PATH" >> .bashrc
	echo '' >> .bashrc
else
	echo 'Golang installed'
fi

cd ${GOPATH}/src/github.com/hyperledger/fabric/
make configtxgen
make cryptogen  
# check combind of 2 results
echo "===================== Crypto tools built successfully ===================== "
echo 
echo "Copying to bin folder of network..."
echo
cp -v ./build/bin/configtxgen /home/$USER/hyperledger-swarm/bin
cp -v ./build/bin/cryptogen /home/$USER/hyperledger-swarm/bin
