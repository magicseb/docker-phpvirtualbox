docker-phpvirtualbox

###FAQ

####Why can't it be run on my machine?
#####There are some limitations that both Host and Container should have the same version of `kernel` and `kernel-devel` while executing `/etc/init.d/vboxdrv setup`. Therefore, I would suggest host and container should run CentOS 7 and then run `yum -y update` on the host, before building the image,

####How to run?
#####see [`run.sh`](https://raw.githubusercontent.com/wood1986/docker-phpvirtualbox/master/run.sh)

####How do I know vbox's password?
#####open `/var/www/phpvirtualbox/config.php`
