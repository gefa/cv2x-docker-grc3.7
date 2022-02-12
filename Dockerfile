FROM ubuntu:18.04

RUN apt-get update && apt-get install gnuradio -y
RUN apt-get install git cmake swig pkg-config -y

RUN git clone https://github.com/kit-cel/gr-lte.git \
&& cd gr-lte\
&& mkdir build\
&& chmod +x cmake_command.sh \
&& cp cmake_command.sh build/ \
&& cd build\
&& ./cmake_command.sh \
&& make\
&& make install\
&& ldconfig

RUN apt-get -y install python-matplotlib

RUN git clone https://github.com/bastibl/gr-ieee802-15-4.git \
    && cd gr-ieee802-15-4 && git checkout maint-3.7 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && ldconfig

RUN git clone https://github.com/hhornbacher/gr-ble.git \
    && cd gr-ble && git checkout master \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && ldconfig

RUN grcc gr-ieee802-15-4/examples/ieee802_15_4_OQPSK_PHY.grc

RUN git clone https://github.com/tapparelj/gr-lora_sdr.git \
&& cd gr-lora_sdr \
&& mkdir build\
&& cd build\
&& cmake ../ \
&& make \
&& make install\
&& ldconfig

RUN git clone https://github.com/bastibl/gr-foo.git \
&& cd gr-foo \
&& git checkout maint-3.7 \
&& mkdir build \
&& cd build \
&& cmake .. \
&& make \
&& make install \
&& ldconfig

ENV GRC_BLOCKS_PATH=$GRC_BLOCKS_PATH:/gr-lora_sdr/grc

RUN sed -i "s/lib64/lib/" /gr-lora_sdr/apps/setpaths.sh
RUN sed -i "s/~/\/root/" /gr-lora_sdr/apps/setpaths.sh
RUN sed -i "s/site/dist/" /gr-lora_sdr/apps/setpaths.sh
RUN cat /gr-lora_sdr/apps/setpaths.sh
# paths should be:
#/root/lora_sdr/lib/python2.7/dist-packages/
#/root/lora_sdr/lib/
# source or export dont work here

RUN git clone git://github.com/bastibl/gr-ieee802-11.git \
    && cd gr-ieee802-11 \
    && git checkout maint-3.7 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && ldconfig
#RUN sysctl -w kernel.shmmax=2147483648

RUN git clone https://github.com/BastilleResearch/scapy-radio.git \
&& cd scapy-radio \
&& sed -i "s/sudo//" install.sh\
&& ./install.sh

ENV PYTHONPATH=$PYTHONPATH:/root/lora_sdr/lib/python2.7/dist-packages
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/lora_sdr/lib/
RUN grcc /gr-ieee802-11/examples/wifi_phy_hier.grc
#RUN chmod +x /home/gnuradio/.grc_gnuradio/wifi_phy_hier.py
RUN /usr/bin/uhd_images_downloader
RUN apt install -y wireless-tools net-tools iproute2 tcpdump

RUN git clone https://github.com/gefa/gr-lora.git \
&& cd gr-lora \
&& git checkout main \
&& mkdir build \
&& cd build \
&& cmake .. \
&& make \
&& make install \
&& ldconfig

RUN apt install -y librtlsdr-dev
RUN git clone https://github.com/sdrplay/gr-osmosdr \
    && cd gr-osmosdr && git checkout master \
    && mkdir build \
    && cd build \
    && cmake -DENABLE_RTL=ON -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON .. \
    && make \
    && make install \
    && ldconfig

RUN apt update && apt install -y apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
RUN add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
RUN apt update && apt install -y sublime-text

#RUN apt update && apt install -y python3.8
RUN apt-get update && apt-get install -y python3-dev python3-pip build-essential libzmq3-dev
RUN pip3 install pyzmq
#ENTRYPOINT ["/bin/bash"]
