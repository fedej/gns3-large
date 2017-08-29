# Version: 0.8.0
FROM alpine:edge
MAINTAINER fedej
#
# increase the version to force recompilation of everything
#
ENV GNS3LARGEVERSION 0.0.1
#
# ------------------------------------------------------------------
# environment variables to avoid that dpkg-reconfigure
# tries to ask the user any questions
#
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

#
# -----------------------------------------------------------------
# install needed packages to build and run gns3 and related sw
#
ENV depends="\
    gns3-gui\
    gns3-server\
    ttf-ubuntu-font-family\
    wireshark\
    xkeyboard-config\
    xterm\
    dynamips\
    qemu-img\
    qemu-system-x86_64\
    ubridge\
    iproute2\
    iptables\
    vpcs\
    iniparser\
    dbus\
    iouyap\
    openssl\
    py-pip\
    shadow\
    bash\
    sudo\
    heimdal-telnet\
"

sudo ln -s /usr/bin/ktelnet /usr/bin/telnet

RUN sed -n "s/main/testing/p" /etc/apk/repositories >> /etc/apk/repositories\
 && apk add --no-cache $depends

#
#
# prepare startup files /src/misc
#
RUN mkdir -p /src/misc

ADD startup.sh /src/misc/startup.sh
ADD iourc.sample /src/misc/iourc.txt

RUN chmod a+x /src/misc/startup.sh
ENTRYPOINT cd /src/misc ; ./startup.sh
