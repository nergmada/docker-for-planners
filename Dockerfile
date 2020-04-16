FROM ubuntu:18.04

# maintainer information
LABEL maintainer="Christian Muise (christian.muise@queensu.ca)"

# update the apt package manager
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get update && apt-get -y install locales

# Install required packages
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	ca-certificates \
	curl \
	scons \
	gcc-multilib \
	flex \
	bison \
        vim \
        git \
	cmake \
	unzip \
	g++-multilib

# install python and related
RUN apt-get install -y python3 python3-dev python3-pip python3-venv
RUN pip3 install --upgrade pip

# Set up environment variables
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \ 
	CXX=g++ \
	HOME=/root \
	BASE_DIR=/root/projects


# Create required directories
RUN mkdir -p $BASE_DIR
WORKDIR $BASE_DIR


#################################
# Download and Install Pyperplan
#################################
ENV PYPERPLAN_URL=https://github.com/aibasel/pyperplan/archive/master.tar.gz
RUN curl -SL $PYPERPLAN_URL | tar -xz \
        && mv pyperplan-* pyperplan
RUN echo 'alias pyperplan="python3 ${BASE_DIR}/pyperplan/src/pyperplan.py"' >> ~/.bashrc


#################################
# Download and Install Fast Downward
#################################
ENV FD_URL=http://hg.fast-downward.org/archive/tip.tar.gz
RUN curl -SL $FD_URL | tar -xz \
	&& mv Fast-Downward* fast-downward \
	&& cd fast-downward \
	&& python3 ./build.py -j 2
RUN echo 'alias fd="python3 ${BASE_DIR}/fast-downward/fast-downward.py"' >> ~/.bashrc


#################################
# Download and Install K*
#################################
ENV KSTAR_URL=https://github.com/ctpelok77/kstar/archive/master.tar.gz
RUN curl -SL $KSTAR_URL | tar -xz \
        && mv kstar-* kstar \
	&& cd kstar \
	&& python3 ./build.py release64 
RUN echo 'alias kstar="python3 ${BASE_DIR}/kstar/fast-downward.py --build release64"' >> ~/.bashrc

# default command to execute when container starts
CMD /bin/bash
