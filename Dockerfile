# A portable reverse engineering and exploit development environment using docker
FROM ubuntu:22.04

# --------------------------------------------------------------------
# 1) ARGs & ENV Vars
# --------------------------------------------------------------------
ARG DEBIAN_FRONTEND=noninteractive
ARG username="pwn"
ARG password="docker"

ENV TZ=Etc/UTC
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# --------------------------------------------------------------------
# 2) Prepare apt and fix possible GPG signature issues
# --------------------------------------------------------------------

RUN apt-get update && apt-get upgrade -y
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        gnupg2              \
        ca-certificates     \
        apt-transport-https

# --------------------------------------------------------------------
# 3) Add i386 architecture, upgrade system, install all tools
# --------------------------------------------------------------------
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y --no-install-recommends \
        autoconf            \
        binwalk             \
        bsdiff              \
        build-essential     \
        clang               \
        cmake               \
        curl                \
        default-jdk         \
        exiftool            \
        gcc-multilib        \
        g++-multilib        \
        gdb                 \
        gdb-multiarch       \
        git                 \
        ipython3            \
        libcapstone-dev     \
        libc6:i386          \
        libc6-dbg           \
        libc6-dbg:i386      \
        libc6-dev-i386      \
        libffi-dev          \
        libglib2.0-dev      \
        libini-config-dev   \
        libncurses5:i386    \
        libseccomp-dev      \
        libssl-dev          \
        libstdc++6:i386     \
        libtool-bin         \
        lldb                \
        llvm                \
        locales             \
        ltrace              \
        man-db              \
        manpages-posix      \
        nasm                \
        neovim              \
        netcat              \
        net-tools           \
        nmap                \
        python3             \
        python3-binwalk     \
        python3-dev         \
        python3-pip         \
        python3-setuptools  \
        rubygems            \
        ruby-dev            \
        socat               \
        squashfs-tools      \
        strace              \
        sudo                \
        tcpdump             \
        tmux                \
        tzdata              \
        unzip               \
        vim                 \
        wget                \
        xxd                 \
        zip && \
    # Clean up apt cache to keep the image small
    rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------------
# 4) Generate locale
# --------------------------------------------------------------------
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

# --------------------------------------------------------------------
# 5) Create user, setup passwordless sudo
# --------------------------------------------------------------------
RUN useradd -ms /bin/bash ${username} && \
    echo "${username}:${password}" | chpasswd && \
    usermod -aG sudo ${username} && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# --------------------------------------------------------------------
# 6) Copy tmux config & fix ownership
# --------------------------------------------------------------------
COPY .tmux.conf /home/${username}/.tmux.conf
RUN chown ${username}:${username} /home/${username}/.tmux.conf

# --------------------------------------------------------------------
# 7) Create workspace directory (GitTools) & set it as WORKDIR
# --------------------------------------------------------------------
RUN mkdir /home/${username}/GitTools && \
    chown -R ${username}:${username} /home/${username}/GitTools
WORKDIR /home/${username}/GitTools

# --------------------------------------------------------------------
# 8) Switch to user, install GEF, Radare2 & python libraries
# --------------------------------------------------------------------

RUN pip3 install --no-cache-dir \
    capstone \
    ropper \
    pwn \
    numpy \
    PyCryptodome \
    unicorn \
    keystone-engine

USER ${username}

RUN git clone https://github.com/hugsy/gef.git /home/${username}/GitTools/gef && \
    echo 'source /home/${username}/GitTools/gef/gef.py' >> ~/.gdbinit

RUN git clone https://github.com/radareorg/radare2.git /home/${username}/GitTools/radare2 && \
    /home/${username}/GitTools/radare2/sys/install.sh

# --------------------------------------------------------------------
# 9) Default shell
# --------------------------------------------------------------------
CMD ["/bin/bash"]
