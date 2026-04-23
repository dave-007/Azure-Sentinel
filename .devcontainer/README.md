# Devcontainer for Microsoft Sentinel Training Lab

This repo includes a devcontainer configuration intended for **GitHub Codespaces** so you can run tooling commonly used in the **Microsoft Sentinel Training Lab**.

## What's included

- Python 3.11 + common Python packages (Jupyter, Azure SDK helpers)
- PowerShell + Az module (best effort)
- Azure CLI (+ Bicep)
- Node.js 20
- VS Code extensions for Azure, Bicep, PowerShell, Python

## Notes / expectations

- The lab itself still requires an Azure subscription and portal steps (creating a Log Analytics workspace, enabling Sentinel, deploying ARM template).
- Authentication to Azure inside the Codespace is typically done with:

  ```bash
  az login --use-device-code
  ```

## Files

- `.devcontainer/devcontainer.json`
- `.devcontainer/postCreateCommand.sh`
