# Base Image
FROM public.ecr.aws/spacelift/runner-terraform:latest

# Set Environment variables
ENV PATH "${PATH}:/home/spacelift/.local/bin:/usr/local/.pyenv/bin"

# Labels
LABEL "maintainer" "Mervin Hemaraju <mervinhemaraju16@gmail.com>"
LABEL "application" "mervinhemaraju.app.spacelift.io"

# Change Work directory
WORKDIR /tmp

# Change user to root
USER root

# Specify python version during image build
ARG PYTHON_VERSION=3.11.6

# Install build dependencies and needed tools
RUN apk add \
    wget \
    gcc \
    make \
    zlib-dev \
    libffi-dev \
    openssl-dev \
    musl-dev

# Download and extract python sources
RUN cd /opt \
    && wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \                                              
    && tar xzf Python-${PYTHON_VERSION}.tgz

# Build python and remove left-over sources
RUN cd /opt/Python-${PYTHON_VERSION} \ 
    && ./configure --prefix=/usr --enable-optimizations --with-ensurepip=install \
    && make install \
    && rm /opt/Python-${PYTHON_VERSION}.tgz /opt/Python-${PYTHON_VERSION} -rf

# Set pip3 as the default pip
RUN ln -sf /usr/bin/pip3 /usr/bin/pip

# Ensure we're using 'spacelift' for actually running the Spacelift Jobs
USER spacelift