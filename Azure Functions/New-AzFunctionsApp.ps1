# General variables for Azure
$resourceGroup = 'azure-functions'
$location = 'westeurope'

# Variables for Azure Functions
$localFunctionDirectory = "github"

$functionAppName = 'microsoft-graph-func'
$functionRuntime = 'PowerShell'
$functionVersion = '3'
$functionLocation = 'West Europe'

# Variables for the trigger inside the Azure Function app
$functionTriggerName = 'getgraph'
$functionTemplate = 'HTTP trigger'
$functionAuthLevel = 'function'

# Variables for Azure Storage Account
# The name of the storage account must be globally unique and cannot contain any special characters nor spaces
$storageAccountName = 'stbpfunctionapps'
$storageSkuName = 'Standard_LRS'

# Install Azure Functions Core Tools v3 for macOS
brew tap azure/functions
brew install azure-functions-core-tools@3

# Set location to the general Function Apps directory
Set-Location $localFunctionDirectory

# Create a new Function app on the local machine only if there is no folder with the name of the function app already present
if (Test-Path "~/$functionDirectory/$functionAppName") {
    $checkAppDir = Read-Host -Prompt "Folder with the Azure Function app name already exists. Maybe this function is already created. Do you want to continue (Y/N)"
    if ($checkAppDir -ne 'Y') {
        Write-Host "Script will now exit because of selection"
        Exit 0
    }
}

else {
    Write-Host "Now creating a new Azure Function app with name: $functionAppName"
    func init $functionAppName --powershell
}

# Set location to the new Function App directory
Set-Location "./$functionAppName"

# Create a new HTTP Function Trigger within the Function App with function level authorisation
func new --name $functionTriggerName --template $functionTemplate --authlevel $functionAuthLevel

# Connect with Azure using your credentials
Connect-AzAccount

# Check if there is already a resource group in the Azure tenant with this name. Otherwise create the resource group
if (Get-AzResourceGroup -Name $resourceGroup -ErrorAction SilentlyContinue) {
    Write-Host "Resource group already exists within this subscription. No need to create a new one"
}

else {
    Write-Host "Creating new resource group in Azure with the name: $resourceGroup"
    New-AzResourceGroup -Name $resourceGroup -Location $location
}

# Create a new storage account when there is no storage account created
if (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -ErrorAction SilentlyContinue) {
    $checkDir = Read-Host -Prompt "Storage account already exists. Do you want to continue (Y/N)"
    if ($checkDir -ne 'Y') {
        Write-Host "Script will now exit because of selection"
        Exit 0
    }
}

else {
    # Try to create a new storage account. It might fail because the name is already in use on Azure. Names should be globally unique
    try {
        Write-Host "Creating new storage account in Azure with the name: $storageAccountName"
        New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -SkuName $storageSkuName -Location $location -ErrorAction Stop
    }
    
    # Script will exist when the name is already in use and/or the storage account could not be created
    catch {
        Write-Host "Could not be created: $($Error[0].Exception.Message). Change values and try again."
        Exit 1
    }
}

if (Get-AzFunctionApp -ResourceGroupName $resourceGroup -Name $functionAppName) {
    Write-Host "Resource group already exists within this subscription. No need to create a new one"

}

else {
    New-AzFunctionApp -Name $functionAppName -ResourceGroupName $resourceGroup -StorageAccount $storageAccountName -Runtime $functionRuntime -FunctionsVersion $functionVersion -Location $functionLocation
}
