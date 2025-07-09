FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    tzdata

RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y \
    wget \
    fontconfig \
    debconf \
    pandoc \
    texlive \
    texlive-xetex \
    texlive-latex-extra \
    fonts-freefont-ttf \
    fonts-roboto \
    fonts-noto-cjk \
    fonts-noto-hinted \
    fonts-noto-unhinted \
    fonts-dejavu \
    lmodern \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN fc-cache -fv