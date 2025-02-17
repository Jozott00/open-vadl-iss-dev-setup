# OpenVADL ISS Dev Setup

This project aims to ease the development and debugging of the OpenVADL ISS. 
It's essentially a devcontainer that mounts all relevant code and outputs to the host, so the code
can be opened by any IDE on the host system. However, building and running the ISS should be done within 
the container, as it provides all relevant dependencies.

## Directory Structure

- `code` contains the `open-vadl` project
- `iss` mounts the generated qemu iss (`/work/iss` within the container)
- `testsuite` contains the `test-suite.yaml` file that specifies ISS tests (for manual debugging)
- `dump` contains the VADL dump files during ISS generation
- `tools` contains all helper scripts to execute different steps during development

## Getting Started

- Download this repository.
- Open it in VSCode (the Devcontainer extension must be installed)
- Execute the VSCode command `Dev Containers: Reopen in Containers...`
    This will build and start the devcontainer and reopens VSCode within it.
    The work direcotyr will be `/work`. If you want to work in some other directory, you can also open
    it within the container with `code /path/to/directory`.
- The initially started container won't have the VADL repository and QEMU ISS set up. To do this run
    ```bash
    bash scripts/getting-started.sh
    ```
    This will download the correct QEMU version and clones the OpenVADL repository to `/code/open-vadl`. 
    Note that your host must have access to the VADL repository via SSH (private key).

- Now you can run 
    ```bash
    run-vadl-build && run-iss-gen-rv64im && run-iss-make rv64im
    ```
    which will build vadl, generates the RV64I ISS and builds the ISS.

- Subsequents start of the devcontainer won't require running the `getting-started.sh`.


## Development

My basic workflow is
- Start VSCode within the container (so that the container is up and running)
- Open `./code/open-vadl` in IntelliJ (relative to this repo on the host)
- Open `./iss` in CLion
- Run all commands such as `run-iss-make`, `run-testsuite`, etc. within the container


## Running tests on the generated ISS

Currently the test framework does only work for rv64i. 
In the `testsuite` directory create a file called `test-suite.yaml` with
```yaml
tests:
- id: MEMTEST
  reg_tests: {}
  asm_core: |-
    li x5, 27
    li x29, 2147484454
    sb x5, 0(x29)
    lb x28, 0(x29)
  reference_exec: qemu-system-riscv64
  reference_regs: [x28, x31]
  ```

Then call `run-testsuite`. This will compile the assembly (with some wrapper) to an elf that is loaded
to the `qemu-system-<arch>` iss and executes it. After execution is finished, the relevant register states are collected
and the `qemu-system-riscv64` is executed as reference. At the end the results of both runs are compared to check
if the generated VADL ISS functions correctly.

This will output a `results.yaml` in the same directory
```yaml
- id: MEMTEST
  result:
    completedStages:
    - COMPILE
    - LINK
    - RUN
    - RUN_REF
    duration: 40.47ms
    errors: []
    qemuLog:
      reference-MEMTEST-MEMTEST: []
      vadl-MEMTEST-MEMTEST:
      - '[STDOUT][VADL] vadl_cpu_class_init'
      - '[STDOUT][VADL] virt_machine_instance_init'
      - '[STDOUT][VADL] virt_machine_init'
      - '[STDOUT][VADL] ram-size: 8000000'
      - '[STDOUT][VADL] sys mem size: 0'
      - ...
    regTests:
      x28:
        expected: 000000000000001b
      x31:
        expected: '0000000000000000'
    status: PASS

```
