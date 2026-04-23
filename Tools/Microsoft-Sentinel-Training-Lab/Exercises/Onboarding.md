# Onboarding — Setting up the environment

#### 🎓 Level: 100 (Beginner)
#### ⌛ Estimated time to complete this lab: 20 minutes

## Objectives

Onboard Microsoft Sentinel and deploy the Training Lab solution used in all subsequent exercises.

## Prerequisites

Complete the [Prerequisites](../README.md#prerequisites) and [Custom Detection Rules Setup](../README.md#custom-detection-rules-setup) sections in the README before starting.

---

## Step 1: Create a Log Analytics workspace

If you already have a workspace, skip to [Step 2](#step-2-add-microsoft-sentinel-to-your-workspace).

<!-- tabs:start -->
#### **Azure portal (default)**

1. In the [Azure portal](https://portal.azure.com/), search for **Sentinel** and select **Microsoft Sentinel**.
2. Select **Create** → **Create a new workspace**.
3. Choose your **Subscription**, **Resource Group**, **Workspace Name**, and **Region**.
4. Select **Review + Create**, then **Create**.

#### **Azure CLI**

> **Note:** You can use Azure Cloud Shell (Bash) or run these commands locally.

1. Sign in (skip if already signed in):

   ```bash
   az login
   ```

2. Set your subscription (optional if you only have one):

   ```bash
   az account set --subscription "<subscriptionIdOrName>"
   ```

3. Create (or reuse) a resource group:

   ```bash
   az group create \
     --name "<resourceGroupName>" \
     --location "<region>"
   ```

4. Create the Log Analytics workspace:

   ```bash
   az monitor log-analytics workspace create \
     --resource-group "<resourceGroupName>" \
     --workspace-name "<workspaceName>" \
     --location "<region>"
   ```

5. (Optional) Capture the workspace resource ID for later steps:

   ```bash
   az monitor log-analytics workspace show \
     --resource-group "<resourceGroupName>" \
     --workspace-name "<workspaceName>" \
     --query id -o tsv
   ```
<!-- tabs:end -->

---

## Step 2: Add Microsoft Sentinel to your workspace

<!-- tabs:start -->
#### **Azure portal (default)**

1. From the [Azure portal](https://portal.azure.com/), search for and select **Microsoft Sentinel**.
<img src="../Images/OnboardingImage1.png" alt="Microsoft Sentinel in the Azure portal navigation" width="600">

2. Select **Create**.
<img src="../Images/OnboardingImage2.png" alt="Create a new Microsoft Sentinel instance" width="600">

3. Select the workspace you created in Step 1 and select **Add**.

#### **Azure CLI**

> Microsoft Sentinel is enabled on a Log Analytics workspace by creating a Sentinel **onboarding state**.

1. Set variables:

   ```bash
   SUBSCRIPTION_ID="<subscriptionId>"
   RESOURCE_GROUP="<resourceGroupName>"
   WORKSPACE_NAME="<workspaceName>"
   ```

2. Get the workspace resource ID:

   ```bash
   WORKSPACE_ID=$(az monitor log-analytics workspace show \
     --resource-group "$RESOURCE_GROUP" \
     --workspace-name "$WORKSPACE_NAME" \
     --query id -o tsv)
   ```

3. Enable Microsoft Sentinel (create onboarding state):

   ```bash
   az rest --method put \
     --url "https://management.azure.com${WORKSPACE_ID}/providers/Microsoft.SecurityInsights/onboardingStates/default?api-version=2024-03-01" \
     --body '{}'
   ```

4. Verify onboarding state:

   ```bash
   az rest --method get \
     --url "https://management.azure.com${WORKSPACE_ID}/providers/Microsoft.SecurityInsights/onboardingStates/default?api-version=2024-03-01"
   ```
<!-- tabs:end -->

---

## Step 3: Access Microsoft Sentinel in the Defender portal

1. Sign in to the [Microsoft Defender portal](https://security.microsoft.com/).
2. Once provisioned, you'll see **Microsoft Sentinel** in the navigation pane. If this is your first time, there may be a delay of a few minutes.
<img src="../Images/OnboardingImage3.png" alt="Microsoft Sentinel in the Defender portal navigation pane" width="600">

3. Go to **Settings > Microsoft Sentinel > Workspaces**, verify your workspace is listed, and click **Connect**.

<img src="../Images/OnboardingImage4.png" alt="Connect workspace in Defender portal settings" width="600">

---

## Step 4: Deploy the Microsoft Sentinel Training Lab Solution

This deploys pre-recorded telemetry (~20 MB) and creates analytics rules, workbooks, watchlists, and playbooks used in the subsequent exercises.

Make sure you have completed the **Custom Detection Rules Setup** from the [README](../README.md) (creating the User-Assigned Managed Identity). You will need the UAMI resource ID during deployment.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FAzure-Sentinel%2Fmaster%2FTools%2FMicrosoft-Sentinel-Training-Lab%2FContent%2FDeployment%2Fsentineltraininglab.json)

1. Select the **Subscription**, **Resource Group**, and **Workspace** from the previous steps.
2. Under **Detection Rules Identity Resource Id**, paste the full resource ID of your UAMI (or leave empty to skip detection rules deployment).
3. Select **Review + create**, then **Create**.

> **Note:** The deployment takes approximately **15 minutes**.

4. Once complete, go back to Microsoft Sentinel — you should see ingested data and recent incidents on the home page.

> **⚠️ Playbook Permissions:** The deployment creates a Logic App with a **System-Assigned Managed Identity**. Grant this identity the **Microsoft Sentinel Contributor** role on the resource group.
> 1. **Resource Group** → **Access control (IAM)** → **Add role assignment**.
> 2. Select **Microsoft Sentinel Contributor**, assign to **Managed identity**, select the Logic App's identity, and **Save**.

---

## Next steps

Continue to **[Exercise 1 — Exploration: Hunting Across Your Data](./E01_exploration.md)**
