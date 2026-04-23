#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating apt and installing base packages"
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  jq \
  unzip \
  zip \
  make \
  git \
  ca-certificates \
  curl

echo "==> Installing bicep CLI (via az) if missing"
if command -v az >/dev/null 2>&1; then
  az bicep install >/dev/null 2>&1 || true
  az bicep upgrade >/dev/null 2>&1 || true
fi

echo "==> Installing Python deps (best-effort)"
# Repo-wide requirements.txt isn't guaranteed; install common tooling.
python -m pip install --upgrade pip
python -m pip install --upgrade \
  requests \
  pyyaml \
  azure-identity \
  azure-mgmt-resource \
  azure-monitor-query \
  pandas \
  jinja2 \
  rich \
  ipykernel \
  notebook \
  jupyterlab \
  pytest \
  black \
  ruff

echo "==> Installing PowerShell Az module (best-effort)"
# This is optional for the lab, but useful for automation and scripting.
# Install for current user scope.
pwsh -NoLogo -NoProfile -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; if (-not (Get-Module -ListAvailable -Name Az.Accounts)) { Install-Module Az -Scope CurrentUser -Force -AllowClobber }" || true

echo "==> Done"
