FROM node:8

USER root

RUN apt-get update || true
RUN apt-get install -y openconnect
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/sbin/sshd", "-D"]

# ENTRYPOINT openconnect usc1-vpn.8x8.com
# ENTRYPOINT /bin/bash
