# VirtualBox 4.3.x
#
# VERSION               0.0.1

FROM ubuntu:14.04
MAINTAINER Jean-Christophe Proulx <j.christophe@devjc.net>

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# We install VirtualBox
RUN wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
RUN sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian trusty contrib" >> /etc/apt/sources.list.d/virtualbox.list'
RUN sudo apt-get update
RUN sudo apt-get install -y virtualbox-4.3

#Downloading Kernel to 3.14.25
RUN cd /tmp
RUN wget \
kernel.ubuntu.com/~kernel-ppa/mainline/v3.14.25-utopic/linux-headers-3.14.25-031425_3.14.25-031425.201411211235_all.deb \
kernel.ubuntu.com/~kernel-ppa/mainline/v3.14.25-utopic/linux-headers-3.14.25-031425-generic_3.14.25-031425.201411211235_amd64.deb \
kernel.ubuntu.com/~kernel-ppa/mainline/v3.14.25-utopic/linux-image-3.14.25-031425-generic_3.14.25-031425.201411211235_amd64.deb

#Installing Kernel to 3.14.25
RUN sudo dpkg -i linux-headers-3.14*.deb linux-image-3.14*.deb

RUN sudo /etc/init.d/vboxdrv setup

# We recompile the kernel module and install it. 
# RUN sudo /etc/init.d/vboxdrv setup

# We install the Extension Pack
RUN VBOX_VERSION=`dpkg -s virtualbox-4.3 | grep '^Version: ' | sed -e 's/Version: \([0-9\.]*\)\-.*/\1/'` ; \
    wget http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack ; \
    sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack ; \
    rm Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack

VOLUME /vbox

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
