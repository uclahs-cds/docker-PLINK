ARG MINIFORGE_VERSION=22.9.0-2
ARG UBUNTU_VERSION=20.04

FROM condaforge/mambaforge:${MINIFORGE_VERSION} AS builder

# Use mamba to install tools and dependencies into /usr/local
ARG PLINK_VERSION=plink_linux_x86_64_20230116
RUN mamba install -qy unzip && \
    wget \
        https://s3.amazonaws.com/plink1-assets/${PLINK_VERSION}.zip \
        -qO /tmp/plink.zip && \
    unzip /tmp/plink.zip -d /usr/local/bin/

# Deploy the target tools into a base image
FROM ubuntu:${UBUNTU_VERSION} AS final
COPY --from=builder /usr/local /usr/local

# Add a new user/group called bldocker
RUN groupadd -g 500001 bldocker && \
    useradd -r -u 500001 -g bldocker bldocker

# Change the default user to bldocker from root
USER bldocker

LABEL   maintainer="Nicholas Wiltsie <nwiltsie@mednet.ucla.edu>" \
        org.opencontainers.image.source=https://github.com/uclahs-cds/docker-PLINK
