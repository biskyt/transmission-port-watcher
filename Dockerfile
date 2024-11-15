FROM alpine:latest

# Install transmission
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl shadow sed tini inotify-tools\
    transmission-cli transmission-remote tzdata && \
    rm -rf /tmp/* && \
    mkdir -p /portforward && \
    touch /portforward/port.dat && \
    /bin/echo "net.core.rmem_max = 4194304" >> /etc/sysctl.d/10-rmem_max.conf

COPY portforward_watcher.sh /usr/bin/

RUN chmod 777 /usr/bin/portforward_watcher.sh

ENV PORTFILENAME=port.dat
ENV TRUSER=admin
ENV TRPASSWORD=admin
ENV TRHOST=host.docker.internal
ENV TRPORT=9091
ENV TZ=Europe/London

VOLUME /portforward

# Set up the healthcheck (redundant as image now terminates after 10 fails)
# HEALTHCHECK --interval=1m --timeout=10s --start-period=1m --retries=5 CMD /usr/local/bin/healthcheck.sh

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/portforward_watcher.sh"]
