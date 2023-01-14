FROM ubuntu:18.04
MAINTAINER Ridwan Shariffdeen <ridwan@comp.nus.edu.sg>
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get update -qq \
 && apt-get upgrade -y \
 && apt-get autoremove -y \
 && apt-get install -y --no-install-recommends  \
      apt-transport-https \
      build-essential

RUN apt-get install -y --no-install-recommends  \
       ant \
       git \
       nano \
       ninja-build \
       pkg-config \
       protobuf-compiler-grpc \
       python \
       python3.8 \
       software-properties-common \
       unzip \
       vim \
       wget \
       zlib1g \
       zlib1g-dev

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# Install Maven
RUN cd /opt && wget https://mirrors.estointernet.in/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz && \
    tar -xvf apache-maven-3.6.3-bin.tar.gz
ENV M2_HOME '/opt/apache-maven-3.6.3'
ENV PATH "$M2_HOME/bin:${PATH}"

# Instead of openjdk-8-jdk, install zulu jdk 8.0 to accomodate Defects4J version 1.5.0 and older
RUN wget -O /tmp/zulu8.deb https://cdn.azul.com/zulu/bin/zulu8.66.0.15-ca-jdk8.0.352-linux_amd64.deb
RUN apt install -y /tmp/zulu8.deb

# Build Defects4J (adapted from https://github.com/rjust/defects4j/blob/master/Dockerfile)
# JDK already set up above, so dont install JDK here
RUN \
  apt-get update -y && \
  apt-get install software-properties-common -y --no-install-recommends && \
  apt-get update -y && \
  apt-get install -y --no-install-recommends \
                git \
                build-essential \
				subversion \
				perl \
				curl \
				unzip \
				cpanminus \
				make


# Build ASTOR

RUN git clone https://github.com/SpoonLabs/astor /opt/astor
WORKDIR /opt/astor
RUN mvn install -DskipTests=true
RUN mvn package -DskipTests=true

