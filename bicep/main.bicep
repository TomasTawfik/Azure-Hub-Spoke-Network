param virtualNetworks_Hup_Vnet_name string = 'Hup-Vnet'
param virtualNetworks_Vnet_One_name string = 'Vnet-One'
param azureFirewalls_Hub_Firewall_name string = 'Hub-Firewall'
param routeTables_RT_Spoke_Egress_name string = 'RT-Spoke-Egress'
param networkSecurityGroups_NSG_DB_name string = 'NSG-DB'
param networkSecurityGroups_NSG_App_name string = 'NSG-App'
param networkSecurityGroups_NSG_Web_name string = 'NSG-Web'
param publicIPAddresses_Firewall_PIP_name string = 'Firewall-PIP'
param firewallPolicies_Hub_Firewall_Policy_name string = 'Hub-Firewall-Policy'
param publicIPAddresses_public_ip_formanagment_name string = 'public-ip-formanagment'

resource firewallPolicies_Hub_Firewall_Policy_name_resource 'Microsoft.Network/firewallPolicies@2024-07-01' = {
  name: firewallPolicies_Hub_Firewall_Policy_name
  location: 'francecentral'
  properties: {
    sku: {
      tier: 'Basic'
    }
    threatIntelMode: 'Alert'
  }
}

resource networkSecurityGroups_NSG_App_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroups_NSG_App_name
  location: 'francecentral'
  properties: {
    securityRules: [
      {
        name: 'Wep-to-app'
        id: networkSecurityGroups_NSG_App_name_Wep_to_app.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '3306'
          sourceAddressPrefix: '10.0.1.0/24'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_NSG_DB_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroups_NSG_DB_name
  location: 'francecentral'
  properties: {
    securityRules: [
      {
        name: 'APP-TO-DB'
        id: networkSecurityGroups_NSG_DB_name_APP_TO_DB.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: '10.0.2.0/24'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_NSG_Web_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroups_NSG_Web_name
  location: 'francecentral'
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP'
        id: networkSecurityGroups_NSG_Web_name_Allow_HTTP.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-HTTPS'
        id: networkSecurityGroups_NSG_Web_name_Allow_HTTPS.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_Firewall_PIP_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_Firewall_PIP_name
  location: 'francecentral'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '3'
    '2'
    '1'
  ]
  properties: {
    ipAddress: '40.66.60.223'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'Disabled'
    }
  }
}

resource publicIPAddresses_public_ip_formanagment_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_public_ip_formanagment_name
  location: 'francecentral'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.216.176.176'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource routeTables_RT_Spoke_Egress_name_resource 'Microsoft.Network/routeTables@2024-07-01' = {
  name: routeTables_RT_Spoke_Egress_name
  location: 'francecentral'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'Default-To-Firewall'
        id: routeTables_RT_Spoke_Egress_name_Default_To_Firewall.id
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.1.0.4'
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
    ]
  }
}

resource networkSecurityGroups_NSG_Web_name_Allow_HTTP 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_Web_name}/Allow-HTTP'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '80'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_Web_name_resource
  ]
}

resource networkSecurityGroups_NSG_Web_name_Allow_HTTPS 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_Web_name}/Allow-HTTPS'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 110
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_Web_name_resource
  ]
}

resource networkSecurityGroups_NSG_DB_name_APP_TO_DB 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_DB_name}/APP-TO-DB'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '1433'
    sourceAddressPrefix: '10.0.2.0/24'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_DB_name_resource
  ]
}

resource networkSecurityGroups_NSG_App_name_Wep_to_app 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_NSG_App_name}/Wep-to-app'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '3306'
    sourceAddressPrefix: '10.0.1.0/24'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_NSG_App_name_resource
  ]
}

resource routeTables_RT_Spoke_Egress_name_Default_To_Firewall 'Microsoft.Network/routeTables/routes@2024-07-01' = {
  name: '${routeTables_RT_Spoke_Egress_name}/Default-To-Firewall'
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.1.0.4'
  }
  dependsOn: [
    routeTables_RT_Spoke_Egress_name_resource
  ]
}

resource virtualNetworks_Hup_Vnet_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworks_Hup_Vnet_name
  location: 'francecentral'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        id: virtualNetworks_Hup_Vnet_name_AzureFirewallSubnet.id
        properties: {
          addressPrefixes: [
            '10.1.0.0/26'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_Hup_Vnet_name_GatewaySubnet.id
        properties: {
          addressPrefixes: [
            '10.1.2.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'AzureFirewallManagementSubnet'
        id: virtualNetworks_Hup_Vnet_name_AzureFirewallManagementSubnet.id
        properties: {
          addressPrefixes: [
            '10.1.1.0/26'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'Spoke-to-Hub'
        id: virtualNetworks_Hup_Vnet_name_Spoke_to_Hub.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_Vnet_One_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_Hup_Vnet_name_AzureFirewallManagementSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Hup_Vnet_name}/AzureFirewallManagementSubnet'
  properties: {
    addressPrefixes: [
      '10.1.1.0/26'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Hup_Vnet_name_resource
  ]
}

resource virtualNetworks_Hup_Vnet_name_AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Hup_Vnet_name}/AzureFirewallSubnet'
  properties: {
    addressPrefixes: [
      '10.1.0.0/26'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Hup_Vnet_name_resource
  ]
}

resource virtualNetworks_Hup_Vnet_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Hup_Vnet_name}/GatewaySubnet'
  properties: {
    addressPrefixes: [
      '10.1.2.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Hup_Vnet_name_resource
  ]
}

resource virtualNetworks_Vnet_One_name_DB 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Vnet_One_name}/DB'
  properties: {
    addressPrefixes: [
      '10.0.3.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_DB_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Vnet_One_name_resource
  ]
}

resource virtualNetworks_Vnet_One_name_Hub_to_Spoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-07-01' = {
  name: '${virtualNetworks_Vnet_One_name}/Hub-to-Spoke'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_Hup_Vnet_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_Vnet_One_name_resource
  ]
}

resource virtualNetworks_Hup_Vnet_name_Spoke_to_Hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-07-01' = {
  name: '${virtualNetworks_Hup_Vnet_name}/Spoke-to-Hub'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_Vnet_One_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_Hup_Vnet_name_resource
  ]
}

resource virtualNetworks_Vnet_One_name_App 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Vnet_One_name}/App'
  properties: {
    addressPrefixes: [
      '10.0.2.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_App_name_resource.id
    }
    routeTable: {
      id: routeTables_RT_Spoke_Egress_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Vnet_One_name_resource
  ]
}

resource virtualNetworks_Vnet_One_name_Web 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_Vnet_One_name}/Web'
  properties: {
    addressPrefixes: [
      '10.0.1.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_NSG_Web_name_resource.id
    }
    routeTable: {
      id: routeTables_RT_Spoke_Egress_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_Vnet_One_name_resource
  ]
}

resource azureFirewalls_Hub_Firewall_name_resource 'Microsoft.Network/azureFirewalls@2024-07-01' = {
  name: azureFirewalls_Hub_Firewall_name
  location: 'francecentral'
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Basic'
    }
    threatIntelMode: 'Alert'
    additionalProperties: {}
    managementIpConfiguration: {
      name: 'public-ip-formanagment'
      id: '${azureFirewalls_Hub_Firewall_name_resource.id}/azureFirewallIpConfigurations/public-ip-formanagment'
      properties: {
        publicIPAddress: {
          id: publicIPAddresses_public_ip_formanagment_name_resource.id
        }
        subnet: {
          id: virtualNetworks_Hup_Vnet_name_AzureFirewallManagementSubnet.id
        }
      }
    }
    ipConfigurations: [
      {
        name: 'Firewall-PIP'
        id: '${azureFirewalls_Hub_Firewall_name_resource.id}/azureFirewallIpConfigurations/Firewall-PIP'
        properties: {
          publicIPAddress: {
            id: publicIPAddresses_Firewall_PIP_name_resource.id
          }
          subnet: {
            id: virtualNetworks_Hup_Vnet_name_AzureFirewallSubnet.id
          }
        }
      }
    ]
    networkRuleCollections: []
    applicationRuleCollections: []
    natRuleCollections: []
    firewallPolicy: {
      id: firewallPolicies_Hub_Firewall_Policy_name_resource.id
    }
  }
}

resource virtualNetworks_Vnet_One_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworks_Vnet_One_name
  location: 'francecentral'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'DB'
        id: virtualNetworks_Vnet_One_name_DB.id
        properties: {
          addressPrefixes: [
            '10.0.3.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_DB_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'Web'
        id: virtualNetworks_Vnet_One_name_Web.id
        properties: {
          addressPrefixes: [
            '10.0.1.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_Web_name_resource.id
          }
          routeTable: {
            id: routeTables_RT_Spoke_Egress_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'App'
        id: virtualNetworks_Vnet_One_name_App.id
        properties: {
          addressPrefixes: [
            '10.0.2.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_NSG_App_name_resource.id
          }
          routeTable: {
            id: routeTables_RT_Spoke_Egress_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'Hub-to-Spoke'
        id: virtualNetworks_Vnet_One_name_Hub_to_Spoke.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_Hup_Vnet_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.1.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.1.0.0/16'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}
