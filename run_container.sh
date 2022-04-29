#!/bin/bash

docker run -it \
    --privileged \
    -v $(pwd)/share_ro:/share_ro:ro \
    -v $(pwd)/share_rw:/share_rw \
    pwn_lab

