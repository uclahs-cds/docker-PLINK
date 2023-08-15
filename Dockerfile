ARG MINIFORGE_VERSION=22.9.0-2
ARG UBUNTU_VERSION=20.04

FROM condaforge/mambaforge:${MINIFORGE_VERSION} AS builder

# Use mamba to install tools and dependencies into /usr/local
ARG PLINK_VERSION=plink_linux_x86_64_20230116
ARG PLINK_HASH="7943a976aa1b4481bd489d92c897feb0d96221104416e529175b5302625ddb0e plink.zip"
WORKDIR /tmp

RUN mamba install -qy unzip && \
    wget \
        https://s3.amazonaws.com/plink1-assets/${PLINK_VERSION}.zip \
        -qO /tmp/plink.zip

# Split this into a separate RUN command to make the failure case a little more
# readable
RUN echo ${PLINK_HASH} | sha256sum -c - || \
    { echo Plink release has invalid hash; exit 1; } && \
    unzip /tmp/plink.zip -d /usr/local/bin/

# Deploy the target tools into a base image
FROM ubuntu:${UBUNTU_VERSION} AS final
COPY --from=builder /usr/local /usr/local

# Add a new user/group called bldocker
RUN groupadd -g 500001 bldocker && \
    useradd -r -u 500001 -g bldocker bldocker

# Change the default user to bldocker from root
USER bldocker

ENTRYPOINT ["plink"]

LABEL   maintainer="Nicholas Wiltsie <nwiltsie@mednet.ucla.edu>" \
        org.opencontainers.image.source=https://github.com/uclahs-cds/docker-PLINK
