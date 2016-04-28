#!/bin/bash

apt-get update && apt-get install -y wget apt-transport-https ca-certificates software-properties-common

ppas=("ubuntu-elisp/ppa" "brightbox/ruby-ng" "git-core/ppa")
for ppa in ${ppas[@]}
do
    apt-add-repository ppa:$ppa -y
done

## using /etc/os-release for codename so it works on ubuntu-based distributions like linux mint
#codename=$(lsb_release -c | awk '{print $2}')
codename=$(grep VERSION /etc/os-release | awk 'match($3, /[a-zA-Z]+/){print tolower(substr($3, RSTART, RLENGTH))}')

#virtualbox
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | apt-key add -
echo "deb http://download.virtualbox.org/virtualbox/debian $codename contrib" | tee /etc/apt/sources.list.d/virtualbox.list

#docker
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-$codename main" | tee /etc/apt/sources.list.d/docker.list

apt-get update
#apt-get install emacs-snapshot-nox ruby2.2 ruby2.2-dev git virtualbox-5.0 docker-engine -y
