# Self-Hosted Runner Setup for Theos Builds

This guide documents how to prepare a Linux-based GitHub Actions self-hosted runner that can compile the Dab iOS project using [Theos](https://theos.dev/). The process is split into three stages:

1. Provisioning the runner machine.
2. Installing Theos and required toolchains.
3. Wiring the runner into GitHub Actions for continuous integration.

## 1. Provision the Runner Machine

1. Start from an Ubuntu 22.04 LTS host (physical, VM, or container) with at least 2 CPU cores, 4 GB RAM, and 20 GB free disk space.
2. Create a dedicated system user, e.g. `dab-runner`, and install the GitHub Actions runner binary following the [official documentation](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners).
3. When prompted during runner registration, add the custom label `theos` in addition to the defaults (`self-hosted`, `linux`, `X64`). The workflow defined in this repository uses the `theos` label to target the correct machine.

> **Tip:** Place the runner service files under `/opt/actions-runner` and install it as a systemd service so that it automatically restarts after reboots.

## 2. Install Theos and Toolchains

We provide a helper script that bootstraps the environment with all required packages and Theos dependencies.

```bash
# From the repository root
sudo ios/Scripts/setup-theos-runner.sh
```

The script performs the following tasks:

- Installs compilers and utilities: `clang`, `llvm`, `make`, `cmake`, `ldid`, `fakeroot`, etc.
- Configures the Procursus APT repository (only once) to supply modern iOS tooling such as `ldid`.
- Clones or updates the [`theos/theos`](https://github.com/theos/theos) and [`theos/templates`](https://github.com/theos/templates) repositories under `~/theos` for the runner user.
- Appends `THEOS` and `PATH` exports to the runner user's `~/.profile` so the environment is available for both interactive shells and GitHub Actions jobs.

After running the script, restart the GitHub Actions runner service so that the refreshed environment variables take effect:

```bash
sudo systemctl restart actions.runner.<org>-<repo>.service
```

Replace `<org>` and `<repo>` with the actual values shown when the runner service was installed.

## 3. Configure GitHub Actions

This repository now includes a workflow (`.github/workflows/theos-build.yml`) that targets the `theos`-labeled self-hosted runner. The workflow executes the following steps on every push and pull request:

1. Checkout the repository.
2. Source the Theos environment exports.
3. Invoke `make package` (or another target you configure) to build the project.
4. Archive any generated `.deb` artifacts for download.

If your Theos project uses a different build command or workspace, update the workflow accordingly.

### Testing the Setup Locally

Before relying on CI, manually validate the runner environment:

```bash
source ~/.profile
make clean package
```

Ensure the build completes without errors and that the resulting package appears under `packages/`.

## Troubleshooting

- **Missing SDKs:** Theos requires an iOS SDK. If you do not have one, download the latest SDK from your macOS toolchain and place it under `$THEOS/sdks/`.
- **Permission errors:** Confirm the runner user owns the `~/theos` directory and the repository workspace. Avoid running the GitHub Actions service as `root`.
- **Outdated toolchain:** Re-run `ios/Scripts/setup-theos-runner.sh` periodically to pull the latest Theos commits and ensure dependencies remain up to date.

With these steps complete, your Linux self-hosted runner can continuously build the Dab iOS project using Theos.
