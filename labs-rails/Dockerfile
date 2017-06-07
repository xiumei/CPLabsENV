FROM fedora23-systemd

RUN dnf install -y rubygem-rails ruby-devel mysql-devel postgresql-devel sqlite-devel systemtap-devel rpmdevtools nodejs
#                      rails         ffi       mysql         sqlite         sqlite         ffi            ffi     js env

RUN useradd -u 1000 labsapp
RUN echo 'export LOCAL_BOX="true"' >> /home/labsapp/.bashrc
RUN echo 'export OPENSHIFT_MYSQL_DB_USERNAME="root"' >> /home/labsapp/.bashrc
RUN echo 'export OPENSHIFT_MYSQL_DB_PASSWORD=$MYSQL_ENV_MYSQL_ROOT_PASSWORD' >> /home/labsapp/.bashrc
RUN echo 'export OPENSHIFT_MYSQL_DB_HOST=$MYSQL_PORT_3306_TCP_ADDR' >> /home/labsapp/.bashrc
RUN echo 'export OPENSHIFT_APP_NAME="labsapp"' >> /home/labsapp/.bashrc
RUN echo 'export RAILS_DB="mysql"' >> /home/labsapp/.bashrc

# mongo db params
RUN echo 'export OPENSHIFT_MONGODB_DB_HOST="$MONGO_PORT_27017_TCP_ADDR"' >> /home/labsapp/.bashrc
RUN echo 'export OPENSHIFT_MONGODB_DB_PORT="$MONGO_PORT_27017_TCP_PORT"' >> /home/labsapp/.bashrc

ADD serve /bin/serve
RUN chmod +x /bin/serve

RUN mkdir /labsapp
RUN chown -R labsapp:labsapp /labsapp

USER labsapp