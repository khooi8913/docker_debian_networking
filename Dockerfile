FROM debian:bullseye
LABEL maintainer="cslev <cslev@gmx.com>"

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
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $DEPS && \
    pip3 install tcconfig && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    source /root/.bashrc && \
    echo ENABLED=\"true\" > /etc/default/sysstat

WORKDIR /root
