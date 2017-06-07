FROM fedora23-systemd

RUN dnf install -y httpd mod_ssl
RUN mkdir /etc/httpd/myconf.d
RUN echo 'IncludeOptional myconf.d/*.conf' >> /etc/httpd/conf/httpd.conf
ADD labs.crt /etc/pki/tls/certs/labs.crt
ADD labs.key /etc/pki/tls/private/labs.key

# embeded only
ADD create-conf /bin/create-conf
RUN chmod +x /bin/create-conf

COPY httpd-foreground /usr/local/bin/
RUN chmod +x /usr/local/bin/httpd-foreground
CMD ["httpd-foreground"]