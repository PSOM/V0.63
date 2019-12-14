FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y curl 
RUN apt-get install -y bash 
RUN apt-get install -y grep
RUN apt-get install -y curl 
RUN apt-get install -y python3
RUN apt-get install -y git
RUN apt-get install -y gfortran
RUN apt-get install -y vim
RUN apt-get install -y libnetcdf-dev libnetcdff-dev
COPY ./install_netcdf.sh /tmp/install_netcdf.sh
RUN /tmp/install_netcdf/install_netcdf.sh

# Add GOTM Dependendicies
RUN apt-get install -y cmake
RUN mkdir -p /tmp/gotmbuild && mkdir -p /tmp/gotmsource
WORKDIR /tmp/gotmsource
ENV GOTM_BASE="/tmp/gotmsource/code"
RUN git clone -q --recursive https://github.com/gotm-model/code.git
WORKDIR /tmp/gotmbuild
RUN $GOTM_BASE/scripts/linux/gotm_configure.sh 
RUN $GOTM_BASE/scripts/linux/gotm_build.sh
ENV PATH="/root/local/gotm/gfortran/bin:${PATH}"


WORKDIR /usr/temp/pypsom

ENTRYPOINT ["bash"]

LABEL Author="PyPSOM Team"
LABEL version="0.63.1"

