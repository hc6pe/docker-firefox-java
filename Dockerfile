FROM centos:centos6.9

MAINTAINER Uwe Grawert

ARG JAVA_VERSION=1.8.0
COPY CentOS-Base.repo /etc/yum.repos.d/
RUN ulimit -n 1024000 && yum install --assumeyes firefox \
                            java-$JAVA_VERSION-openjdk \
                            libcanberra-gtk2 \
                            icedtea-web \
                            dbus-x11

RUN groupadd firefox && \
    useradd --home-dir /home/firefox --gid firefox firefox && \
    mkdir -p /home/firefox/.local/share/applications && \
    chown -R firefox:firefox /home/firefox && \
    dbus-uuidgen > /var/lib/dbus/machine-id

COPY start-firefox.sh /
COPY --chown=firefox:firefox defaults.list /home/firefox/.local/share/applications
COPY --chown=firefox:firefox java-webstart.desktop /home/firefox/.local/share/applications
COPY mozilla.cfg /usr/lib64/firefox/defaults/preferences/all-redhat.js

CMD ["/start-firefox.sh"]
