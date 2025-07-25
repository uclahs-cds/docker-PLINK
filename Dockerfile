ARG MINIFORGE_VERSION=22.9.0-2
ARG UBUNTU_VERSION=20.04

FROM condaforge/mambaforge:${MINIFORGE_VERSION} AS builder

# Use mamba to install tools and dependencies into /usr/local
ARG PLINK_VERSION=plink_linux_x86_64_20250615
ARG PLINK_HASH="52571583a4b1a648ed598322e0df0e71ce5d817a23c3c37b2291bd21b408a955 plink.zip"
WORKDIR /tmp

RUN mamba install -qy unzip && \
    wget \
        https://s3.amazonaws.com/plink1-assets/${PLINK_VERSION}.zip \
        -qO /tmp/plink.zip

# Ensure Docker is using bash to evaluate this pipeline
# Split this into a separate RUN command to make the failure case a little more
# readable
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo ${PLINK_HASH} | sha256sum -c - || \
    { echo Plink release has invalid hash; exit 1; } && \
    unzip /tmp/plink.zip -d /usr/local/bin/

# Deploy the target tools into a base image
FROM ubuntu:${UBUNTU_VERSION} AS final
COPY --from=builder /usr/local /usr/local

# Add a new user/group called bldocker
RUN groupadd -g 500001 bldocker && \
    # Add a system user 'bldocker' with restricted logging (-l flag) to prevent
    # entries in lastlog and faillog databases. This is intentional to reduce
    # unnecessary logging in a containerized environment where interactive logins
    # are not expected.
    useradd -r -l -u 500001 -g bldocker bldocker

# Change the default user to bldocker from root
USER bldocker

LABEL   maintainer="Nicholas Wiltsie <nwiltsie@mednet.ucla.edu>" \
        org.opencontainers.image.source=https://github.com/uclahs-cds/docker-PLINK
