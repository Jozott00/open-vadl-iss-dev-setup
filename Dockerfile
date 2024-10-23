FROM jozott/qemu:latest

RUN apt update \
    && apt install -y \
    openjdk-17-jdk \
    openjdk-17-jre \
    ccache

RUN pip install pyyaml qemu.qmp

ARG OPEN_VADL_GIT_REPO=git@ea.complang.tuwien.ac.at:vadl/open-vadl.git
ENV OPEN_VADL_GIT_REPO=${OPEN_VADL_GIT_REPO}

# Add tools to path
ENV PATH="/tools:${PATH}"

ENV ISS_DIR=/gen/output/iss
ENV VADL_DIR=/code/vadl
ENV OPEN_VADL_DIR=/code/vadl/open-vadl
ENV TOOLS_DIR=/tools
ENV TESTSUITE_DIR=/testsuite
ENV GEN_DIR=/gen

# Add vadl executable to path
ENV PATH="${VADL_DIR}/obj/bin:${PATH}"

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
