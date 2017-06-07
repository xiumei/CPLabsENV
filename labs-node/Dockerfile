FROM fedora23-systemd

RUN dnf clean packages
RUN dnf install -y nodejs npm ruby  git tar which nodejs-bson node-gyp
RUN npm install -g bower grunt-cli accessproxy grunt-contrib-sass n
RUN n 5.11.1
RUN gem install sass
RUN dnf install -y make 
# RUN dnf install -y make gcc-c++*
RUN dnf install -y ruby-devel
RUN gem install compass
#ADD serve-db /bin/serve-db
#RUN chmod +x /bin/serve-db
RUN useradd -u 1000 labsapp
RUN echo 'export NODE_ENV="dev"' >> /home/labsapp/.bashrc
RUN echo 'export MONGOLAB_URI="mongodb://$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/labs"' >> /home/labsapp/.bashrc
RUN source /home/labsapp/.bashrc
ADD serve /bin/serve
RUN chmod +x /bin/serve

RUN mkdir /labsapp
RUN chown -R labsapp:labsapp /labsapp

ENV IP="0.0.0.0"

USER labsapp
