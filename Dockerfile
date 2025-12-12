FROM ghcr.io/openvadl/iss-test-base@sha256:400e4be011ad1e9a5313e404bac0332a1d961e79eec380b859ee0647ca10a198

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

# Install Rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
