FROM ghcr.io/openvadl/iss-test-base@sha256:b06d35aac32965ef48e1e6c8aced83af1bfc2253eccac44e079053f7021d5e3a

RUN apt update \
    && apt install -y \
    openjdk-25-jdk \
    language-pack-en-base \
    ccache

RUN pip install pyyaml qemu.qmp

ARG OPEN_VADL_GIT_REPO=git@github.com:OpenVADL/openvadl.git
ENV OPEN_VADL_GIT_REPO=${OPEN_VADL_GIT_REPO}

# Add tools to path
ENV PATH="/work/tools:/${PATH}"

ENV ISS_DIR=/work/iss
ENV OPEN_VADL_DIR=/work/code/open-vadl
ENV TOOLS_DIR=/work/tools
ENV TESTSUITE_DIR=/work/testsuite
ENV GEN_DIR=/work

# Add vadl executable to path
ENV PATH="${OPEN_VADL_DIR}/vadl-cli/build/install/openvadl/bin:${ISS_DIR}/build:${PATH}"

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
