# A portable reverse engineering environment using docker

FROM debian:stable-slim
MAINTAINER Clément Boin

ARG username="re"
ARG password="docker"

RUN dpkg --add-architecture i386 \
	&& apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y   \
        build-essential     \
        libc6:i386          \
        libncurses5:i386    \
        libstdc++6:i386	    \
        gdb                 \
        strace              \
        ltrace              \
        xxd                 \
        bsdiff              \
        libcapstone-dev     \
        python3             \
        python3-pip         \
        libffi-dev          \
        git                 \
        vim                 \
        wget                \
        llvm                \
        clang               \
        lldb                \
        binwalk             \
        python3-binwalk     \
        sudo                \
        locales             \
        tmux                \
        gcc-multilib        \
        curl                \
        wget                \
        git

# Set up locale for tmux
RUN sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen
RUN locale-gen
COPY .tmux.conf /home/${username}/.tmux.conf

# Create a standard user
RUN useradd -ms /bin/bash ${username}
RUN echo "${username}:${password}" | chpasswd
RUN adduser ${username} sudo
RUN chown ${username} /home/${username}
USER ${username}
WORKDIR /home/${username}

# Install gef
RUN mkdir GitTools
RUN cd GitTools \
        && git clone https://github.com/hugsy/gef.git \
        && ./gef/scripts/gef.sh

# Install radare2
RUN git clone https://github.com/radareorg/radare2 \
	&& ./radare2/sys/install.sh

