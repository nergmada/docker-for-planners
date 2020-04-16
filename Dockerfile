FROM ubuntu:18.04

# maintainer information
LABEL maintainer="Christian Muise (christian.muise@queensu.ca)"

# update the apt package manager
RUN apt-get update
RUN apt-get install -y software-properties-common
#Honestly just easier to add universe and let it give us access to wider PPAs
RUN add-apt-repository universe
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
	g++-multilib \
	wget


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

####################################
# Download and install MetricFF
####################################
RUN wget https://fai.cs.uni-saarland.de/hoffmann/ff/Metric-FF.tgz \
	&& tar -xvzf Metric-FF.tgz \
	&& cd /Metric-FF \
	&& make ff 
RUN echo 'alias ff="python3 ${BASE_DIR}/Metric-FF/metricff' >> ~/.bashrc




# default command to execute when container starts
CMD /bin/bash
