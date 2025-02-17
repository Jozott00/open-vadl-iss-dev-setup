FROM jozott/qemu:latest

RUN apt update \
    && apt install -y \
    openjdk-17-jdk \
    openjdk-17-jre \
    language-pack-en-base \
    ccache

RUN pip install pyyaml qemu.qmp

ARG OPEN_VADL_GIT_REPO=git@ea.complang.tuwien.ac.at:vadl/open-vadl.git
ENV OPEN_VADL_GIT_REPO=${OPEN_VADL_GIT_REPO}

# Add tools to path
ENV PATH="/work/tools:/${PATH}"

ENV ISS_DIR=/work/iss
ENV OPEN_VADL_DIR=/work/code/open-vadl
ENV TOOLS_DIR=/work/tools
ENV TESTSUITE_DIR=/work/testsuite
ENV GEN_DIR=/work

# Add vadl executable to path
ENV PATH="${OPEN_VADL_DIR}/vadl-cli/build/install/openvadl/bin:${PATH}"

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
