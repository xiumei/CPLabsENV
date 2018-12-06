FROM fedora23-systemd

RUN dnf install -y rubygem-rails ruby-devel mysql-devel postgresql-devel sqlite-devel systemtap-devel rpmdevtools nodejs
#                      rails         ffi       mysql         sqlite         sqlite         ffi            ffi     js env

RUN mkdir /labsapp
RUN chown -R labsapp:labsapp /labsapp

USER labsapp