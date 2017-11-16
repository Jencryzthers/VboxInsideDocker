# VirtualBox 4.3.x service
#
# VERSION               0.0.1

FROM rastasheep/ubuntu-sshd:16.04
MAINTAINER Esben Haabendal <esben@haabendal.dk>

ENV DEBIAN_FRONTEND noninteractive

# Install VirtualBox
RUN wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc -O- | apt-key add -
RUN sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list.d/virtualbox.list'
RUN apt-get update
RUN apt-get install -y virtualbox-5.2 || /bin/true
RUN apt-get install -y -f

# Install Virtualbox Extension Pack
RUN VBOX_VERSION=`dpkg -s virtualbox-5.2 | grep '^Version: ' | sed -e 's/Version: \([0-9\.]*\)\-.*/\1/'` ; \
    wget http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack ; \
    VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack ; \
    rm Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack

# The virtualbox driver device must be mounted from host
VOLUME /dev/vboxdrv

RUN wget https://releases.hashicorp.com/vagrant/2.0.1/vagrant_2.0.1_x86_64.deb
RUN dpkg -i vagrant_2.0.1_x86_64.deb
