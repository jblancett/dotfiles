#!/bin/bash

ppas=("ubuntu-elisp/ppa" "brightbox/ruby-ng" "git-core/ppa")
for ppa in ${ppas[@]}
do
    sudo apt-add-repository ppa:$ppa -y
done

## using /etc/os-release for codename so it works on ubuntu-based distributions like linux mint
#codename=$(lsb_release -c | awk '{print $2}')
codename=$(grep VERSION /etc/os-release | awk '{print tolower($3)}')

#virtualbox
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
echo "deb http://download.virtualbox.org/virtualbox/debian $codename contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

#docker
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-$codename main" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update
