FROM fedora:23

RUN dnf install -y iputils net-tools procps-ng findutils perl-Data-Dumper initscripts
RUN setcap cap_net_raw+ep /usr/bin/ping

ADD dbus.service /usr/lib/systemd/system/dbus.service.d/containerized.conf
ADD systemctl /usr/bin/systemctl

#rpm -qf /bin/ping