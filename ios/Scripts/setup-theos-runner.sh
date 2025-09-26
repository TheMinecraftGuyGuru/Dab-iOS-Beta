#!/usr/bin/env bash
set -euo pipefail

# Bootstrap a Linux machine for running Theos builds via a self-hosted GitHub Actions runner.
# Usage: ./setup-theos-runner.sh

if [[ $(id -u) -ne 0 ]]; then
  echo "[setup-theos] Re-running script with sudo for privileged operations"
  exec sudo --preserve-env=THEOS "$0" "$@"
fi

TARGET_USER="${SUDO_USER:-root}"
TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
THEOS_DIR="${THEOS:-$TARGET_HOME/theos}"
PROCUSUS_SOURCE_LIST="/etc/apt/sources.list.d/procursus.list"

log() {
  echo "[setup-theos] $*"
}

log "Updating apt repositories"
apt-get update -y

ensure_package() {
  local package="$1"
  if ! dpkg -s "$package" >/dev/null 2>&1; then
    log "Installing package: $package"
    DEBIAN_FRONTEND=noninteractive apt-get install -y "$package"
  else
    log "Package already installed: $package"
  fi
}

for pkg in git curl make cmake clang llvm lld python3 python3-pip perl unzip rsync fakeroot dpkg-dev libz-dev zstd ca-certificates libssl-dev libxml2-dev gnupg; do
  ensure_package "$pkg"
done

if ! command -v ldid >/dev/null 2>&1; then
  log "Configuring Procursus repository for ldid"
  if [[ ! -f "$PROCUSUS_SOURCE_LIST" ]]; then
    echo "deb [arch=amd64] https://apt.procurs.us/ bullseye main" > "$PROCUSUS_SOURCE_LIST"
  fi
  if ! apt-key list | grep -q "Procursus"; then
    curl -fsSL https://apt.procurs.us/documents/apt-key.gpg | apt-key add -
  fi
  apt-get update -y
  ensure_package ldid
else
  log "ldid already available"
fi

log "Ensuring Theos is present at $THEOS_DIR"
if [[ ! -d "$THEOS_DIR" ]]; then
  git clone --recursive https://github.com/theos/theos.git "$THEOS_DIR"
else
  pushd "$THEOS_DIR" >/dev/null
  git pull --recurse-submodules --ff-only
  git submodule update --init --recursive
  popd >/dev/null
fi

log "Ensuring Theos templates are installed"
if [[ ! -d "$THEOS_DIR/templates" ]]; then
  git clone https://github.com/theos/templates.git "$THEOS_DIR/templates"
else
  pushd "$THEOS_DIR/templates" >/dev/null
  git pull --ff-only
  popd >/dev/null
fi

profile_file="$TARGET_HOME/.profile"

if ! grep -q "export THEOS=" "$profile_file" 2>/dev/null; then
  {
    echo "export THEOS=\"$THEOS_DIR\""
    echo 'export PATH="$THEOS/bin:$PATH"'
  } >> "$profile_file"
  log "Appended THEOS exports to $profile_file"
else
  log "THEOS exports already present in $profile_file"
fi

log "Bootstrap complete. Restart the GitHub Actions runner service to pick up changes if necessary."
