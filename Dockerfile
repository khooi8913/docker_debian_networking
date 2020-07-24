# FROM debian:bullseye
# LABEL maintainer="cslev <cslev@gmx.com>"
FROM ubuntu

COPY password.txt /

RUN apt-get update \
    && apt-get install -y firefox \
                      openssh-server \
                      xauth \
    && mkdir /var/run/sshd \
    && mkdir /root/.ssh \
    && chmod 700 /root/.ssh \
    && ssh-keygen -A \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i "s/^.*PasswordAuthentication.*$/PasswordAuthentication yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
    && grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
    && cat /password.txt /password.txt | passwd 

# RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUazTh4uW31svcn9pP7WFKAq7ouUdyQF9MZCraE6cZ3V7UjQOWNAGTtbgSgDgEb0UEVw3xmFVUhcUfLVUFE58Q5H+/2zXtj1Y+ctxtSdEhcK1nlnyphUt/K0PvMw/OmOVhNjQbz4qhm+h1PewAWHGnW1Ruonk3uBC/9fvQQmMiibGpQpf3+WEnxs12wRfT92hEJSsr6w17ZBNE5URxoGmUevovDPYTv29C/OD8uhy5FVX0Enp6DqhLhfxB9mDFrrlEiYkqgwtUz1ttydstamrUbSD7r4lSY0hFcvVHRy/7glPop6Tqq+m7GH6a3I2Sfktf7Sm3tWdGc9JVpw7VG0+X" >> /root/.ssh/authorized_keys

ENV DEPS tshark \
	       tcpdump \
         nano \
         tar \
         bzip2 \
         wget \
         curl \
         python3 \
         python3-scapy \
         iperf3 \
         iperf \
         net-tools \
         iputils-ping \
         arping \
         nmap \
         dnsutils \
         hping3 \
         ethtool \
	 iproute2 \
	iptables\
	sysstat \
	curl \
	bc \
	tcpreplay \
	python3-pip

COPY bashrc_template /root/.bashrc
SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
    # DEBIAN_FRONTEND=noninteractive 
    apt-get install -y --no-install-recommends $DEPS && \
    pip3 install setuptools && \
    pip3 install tcconfig && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    source /root/.bashrc && \
    echo ENABLED=\"true\" > /etc/default/sysstat

WORKDIR /root
