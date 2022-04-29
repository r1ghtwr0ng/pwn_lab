# A portable reverse engineering and exploit development environment using docker
FROM ubuntu:latest

# Env variables and arguments setup
ARG username="pwn"
ARG password="docker"
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Install required packages
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
        tzdata              \
        git

# Setup the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

# Configure tmux configuration
COPY .tmux.conf /home/${username}/.tmux.conf

# Ensure sudo group users are not 
# asked for a password when using 
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create a standard user
RUN useradd -ms /bin/bash ${username}
RUN echo "${username}:${password}" | chpasswd
RUN adduser ${username} sudo
RUN chown ${username} /home/${username}

# Create directory for git repositories
RUN mkdir /home/${username}/GitTools
WORKDIR /home/${username}/GitTools
RUN chown -R ${username} /home/${username}/GitTools

# Change to re user
USER ${username}

# Install radare2
RUN git clone https://github.com/radareorg/radare2 \
    && ./radare2/sys/install.sh

# Install gef
RUN git clone https://github.com/hugsy/gef.git /home/${username}/GitTools/gef \
    && echo 'source ./gef/gef.py' >> ~/.gdbinit

# Install Python3 packages
RUN pip3 install capstone ropper pwn numpy PyCryptodome unicorn keystone-engine

