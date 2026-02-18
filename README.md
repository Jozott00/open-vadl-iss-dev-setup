# OpenVADL ISS Dev Setup

This project aims to ease the development and debugging of the OpenVADL ISS. 
It's essentially a devcontainer that mounts all relevant code and outputs to the host, so the code
can be opened by any IDE on the host system. However, building and running the ISS should be done within 
the container, as it provides all relevant dependencies.

Tip: On MacOS you may want to use the Orbstack docker engine instead of Docker Desktop, as it gives you
a 3x speed-up when compiling QEMU.

## Directory Structure

- `code` contains the `open-vadl` project
- `iss` mounts the generated qemu iss (`/work/iss` within the container)
- `templates/testsuite` contains tracked template test-suite YAML/TOML files
- `testsuite` is the local working directory for copied test-suite files and results (ignored by git)
- `dump` contains the VADL dump files during ISS generation
- `tools` contains all helper scripts to execute different steps during development

## Getting Started

- Download this repository.
- Open it in VSCode (the Devcontainer extension must be installed)
- Execute the VSCode command `Dev Containers: Reopen in Containers...`
    This will build and start the devcontainer and reopens VSCode within it.
    The work direcotyr will be `/work`. If you want to work in some other directory, you can also open
    it within the container with `code /path/to/directory`.
- Upon restart, the `scripts/post-create.sh` script is executed.
  This will download the correct QEMU version and clones the OpenVADL repository to `/code/open-vadl`. 
- Now you can run 
    ```bash
    run-vadl-build && run-iss-gen-sys risc-v/rv64im.vadl && run-iss-make rv64im
    ```
    which will build vadl, generates the RV64I ISS and builds the ISS.


## Development

My basic workflow is
- Start VSCode within the container (so that the container is up and running)
- Open `./code/open-vadl` in IntelliJ (relative to this repo on the host)
- Open `./iss` in CLion
- Run all commands such as `run-iss-make`, `run-testsuite`, etc. within the container


## Running tests on the generated ISS

PPC64 tests use the CoSim flow via `run-cosim` (for example `run-cosim ppc64`).
Other architectures use the ISS test runner via `run-testsuite` (for example `run-testsuite riscv`).

Copy templates into `testsuite` first:
```bash
copy-testsuite-templates
```

Then edit the copied file in `testsuite` (for example `test-suite-riscv.yaml`):
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

Then call `run-testsuite <name>`, for example:
```bash
run-testsuite riscv
run-testsuite aarch64
```
This resolves to `test-suite-riscv.yaml`, `test-suite-aarch64.yaml`, etc.
You can also pass a full file name (for example `run-testsuite test-suite-riscv.yaml`).

The test run will compile the assembly (with some wrapper) to an elf that is loaded
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
