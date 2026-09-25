#!/usr/bin/env bash
# Lab 03 – Deploy a container to Azure Container Instances
# Usage: ./deploy.sh <resource-group> <container-name> <dns-label>
# Run in Azure Cloud Shell (Bash) or any shell with the Azure CLI signed in.

set -euo pipefail

RG="${1:?Resource group name required}"
NAME="${2:?Container name required (lowercase)}"
DNS="${3:?DNS label required (lowercase, unique in region)}"

az container create \
  --resource-group "$RG" \
  --name "$NAME" \
  --image mcr.microsoft.com/azuredocs/aci-helloworld:latest \
  --dns-name-label "$DNS" \
  --ports 80 \
  --os-type Linux \
  --cpu 1 \
  --memory 1.5

# Show the state and public URL
az container show \
  --resource-group "$RG" \
  --name "$NAME" \
  --query "{State:instanceView.state, FQDN:ipAddress.fqdn}" \
  --output table

echo "Open: http://$DNS.$(az group show -n "$RG" --query location -o tsv).azurecontainer.io"

# Cleanup when finished:
# az container delete --resource-group "$RG" --name "$NAME" --yes
