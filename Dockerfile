FROM nvidia/cuda:11.2.2-base-ubuntu18.04

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

ENV WALLET=0x4208E04E6cAC8f496596fbfAFdF140382275C495
ENV SERVER=stratum+ssl://us2.ethermine.org:5555
ENV WORKER=Rig
ENV ALGO=ethash
ENV PASS=x
ENV API_PASSWORD=Password1

ENV TREX_URL="https://github.com/trexminer/T-Rex/releases/download/0.24.5/t-rex-0.24.5-linux.tar.gz"

ADD config/config.json /home/nobody/

FROM nvidia/cuda:11.2.2-base-ubuntu18.04

RUN set -ex \
  && apt update \
  && apt upgrade -y \
  && apt update \
  && apt install -y \
    bzip2 \
    software-properties-common \
    tzdata \
    wget \
    xterm \
    xinit \
  && add-apt-repository -y ppa:graphics-drivers \
  && apt install -y \
    nvidia-driver-460 \
    nvidia-utils-460 \
    xserver-xorg-video-nvidia-460 \
    nvidia-opencl-dev \
    nvidia-settings \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /trex \
    && wget --no-check-certificate $TREX_URL \
    && tar -xvf ./*.tar.gz  -C /trex \
    && rm *.tar.gz
    

WORKDIR /trex

ADD init.sh /trex/

VOLUME ["/config"]

CMD ["/bin/bash", "init.sh"]
