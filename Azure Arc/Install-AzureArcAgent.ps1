# Install the required module just to be sure
Install-Module Az.ConnectedMachine

# Create a resource group in the selected subscription
New-AzResourceGroup -Name 'azure-arc' -Location 'West Europe'

# Download the agent and deploy the machine in the resource group
Connect-AzConnectedMachine -ResourceGroupName 'azure-arc' -Name 'hostname of your machine' -Location 'West Europe'
