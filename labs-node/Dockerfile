FROM fedora23-systemd

RUN dnf clean packages
RUN dnf install -y nodejs npm ruby  git tar which nodejs-bson node-gyp
RUN npm install -g bower grunt-cli accessproxy grunt-contrib-sass n
RUN n 5.11.1
RUN gem install sass
RUN dnf install -y make ruby-devel
RUN gem install compass

RUN useradd -u 1000 labsapp
ENV NODE_ENV="dev"

RUN mkdir /labsapp
RUN chown -R labsapp:labsapp /labsapp

ENV IP="0.0.0.0"

USER labsapp
