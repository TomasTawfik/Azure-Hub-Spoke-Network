# Azure Hub-Spoke Networking Architecture

## Overview
Enterprise Azure networking project implementing Hub-Spoke topology.

## Architecture
- Hub VNet
- Spoke VNet
- Azure Firewall
- NSG
- Route Table
- VNet Peering

## Technologies
- Microsoft Azure
- ARM Template
- Bicep
- Azure Firewall
- NSG

## Deployment

Deploy ARM:

az deployment group create \
--resource-group RG \
--template-file ARM/template.json \
--parameters ARM/parameters.json

## Documentation
See Documentation folder.

## Demo Video
Google Drive Link:
(https://drive.google.com/drive/folders/1PTR6ZtQf4_7UMnHYYd9tXgSayWCJMwbj?usp=drive_link)

## Learning Outcomes
- Hub-Spoke
- Firewall
- Routing
- Segmentation
