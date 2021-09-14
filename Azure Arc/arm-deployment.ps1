# Connect with the Azure tenant
Connect-AzAccount

$deploymentName = 'azure-arc-deployment'
$resourceGroup = "bp-bjornpetersdev"
$templateFile = '/Users/bjorn/github/powershell-private/Azure Arc/loganalytics-deployment.json'


$workspaceName = 'bp-azu-log-arc'
$location = 'westeurope'

# Create the Log Analytics workspace
New-AzOperationalInsightsWorkspace -Location $location -Name $workspaceName -Sku pergb2018 -ResourceGroupName $resourceGroup

New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroup -TemplateFile $templateFile





Get-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName 'bp-bjornpetersdev' -AutomationAccountName 'bp-azu-aa-arc'