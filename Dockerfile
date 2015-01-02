FROM centos:latest

RUN yum -y update && \
    yum clean all

RUN yum -y install epel-release && \
    yum -y install dkms pwgen

RUN yum -y install wget kernel make kernel-devel gcc unzip php php-soap passwd

RUN wget -O /etc/yum.repos.d/virtualbox.repo "http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo" && \
    yum -y install VirtualBox-4.3 && \
    yum clean all

RUN VERSION=$(VBoxManage -v | tail -1) && \
    VERSION=(${VERSION//r/ }) && \
    EXTPACK=Oracle_VM_VirtualBox_Extension_Pack-${VERSION[0]}-${VERSION[1]}.vbox-extpack && \
    EXTPACK_PATH=/root/$EXTPACK && \
    wget -O $EXTPACK_PATH "http://download.virtualbox.org/virtualbox/"${VERSION[0]}"/"$EXTPACK && \
    VBoxManage extpack install $EXTPACK_PATH && \
    rm -f $EXTPACK_PATH

RUN PHP=phpvirtualbox-4.3-2 && \
    wget -O /var/www/html/$PHP.zip "http://jaist.dl.sourceforge.net/project/phpvirtualbox/"$PHP".zip" && \
    cd /var/www/html && \
    unzip $PHP.zip && \
    rm -rf $PHP.zip && \
    ln -sf $PHP ./phpvirtualbox && \
    cd $PHP && \
    mv config.php-example config.php && \
    PASSWORD=$(pwgen -cnys1 16) && \
    useradd vbox && \
    echo -e "$PASSWORD\n$PASSWORD\n" | passwd vbox && \
    sed "s/'pass'/'"$PASSWORD"'/g" -i config.php

EXPOSE 80 9000

CMD /etc/init.d/vboxdrv setup && \
    /lib/virtualbox/vboxwebsrv -H 0.0.0.0 -b -F /var/log/vboxwebsrv.log && \
    httpd -DFOREGROUND
