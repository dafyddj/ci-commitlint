FROM node:22-bookworm-slim@sha256:f035ba7ffee18f67200e2eb8018e0f13c954ec16338f264940f701997e3c12da

# renovate: datasource=npm depName=@commitlint/cli
ARG CL_CLI_VERSION=19.6.0
# renovate: datasource=npm depName=@commitlint/config-conventional
ARG CL_CC_VERSION=19.6.0

# Avoid unnecessary files when installing packages
COPY files/dpkg-nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc
COPY files/apt-no-recommends /etc/apt/apt.conf.d/99synaptic

SHELL ["/bin/bash", "-x", "-o", "pipefail", "-c"]
RUN : \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
    && git config --global user.name "Null" \
    && git config --global user.email "null@example.com" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN : \
    && npm install -g @commitlint/cli@${CL_CLI_VERSION} \
        @commitlint/config-conventional@${CL_CC_VERSION} \
    && :
