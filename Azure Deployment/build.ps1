# Credentials
$userName = "newuser"
$password = ConvertTo-SecureString "password123" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($userName, $password)

$resourceGroupName = 'TestLab'
$locationName = 'westeurope'

$vmName = 'DC01'
$vmNicName = $vmName + '-nic'
$vmPublicIP = $vmName + '-ip'
$vmSize = 'Standard_B2s'
$publisherName = 'MicrosoftWindowsServer'
$offer = 'WindowsServer'
$skus = '2019-datacenter-gensecond'

$networkName = 'TestLab'
$vnetAddressPrefix = '10.10.0.0/24'
$subnetName = 'TestLab'
$subnetAddressPrefix = '10.10.0.0/24'

# Create a new resource group in Microsoft Azure
New-AzResourceGroup -Name $resourceGroupName -Location $locationName

# Create a public IP address for the VM in Microsoft Azure
$pip = New-AzPublicIpAddress -Name $VMPublicIP -ResourceGroupName $ResourceGroupName -Location $LocationName -AllocationMethod Dynamic

# Create a new virtual network in Microsoft Azure
$subnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix
$vnet = New-AzVirtualNetwork -Name $NetworkName -ResourceGroupName $ResourceGroupName -Location $LocationName -AddressPrefix $VnetAddressPrefix -Subnet $Subnet
$nic = New-AzNetworkInterface -Name $VMNicName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $PIP.Id


New-TestLabVM `
    -Credential $credential `
    -VMName $vmName `
    -VMSize $vmSize `
    -NICID $nic.Id `
    -Skus $skus `
    -Offer $offer `
    -ResourceGroupName $resourceGroupName `
    -LocationName $locationName



$fileUri = "https://storageaccountbpbjoac05.blob.core.windows.net/scripts/Script.ps1"
$script = 'Script.ps1'

Add-ScriptExtension -FileUri $fileUri -Script $script -ResourceGroupName $resourceGroupName -VMName $vmName -LocationName $locationName