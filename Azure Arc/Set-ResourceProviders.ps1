# Connect with the Azure service
Connect-AzAccount

# Get available subscriptions within the tenant
Get-AzSubscription

# Set the context to the selected subscription
Set-AzContext -SubscriptionId 'subscription ID you want to use'

# Register the required resource providers for Azure Arc
Register-AzResourceProvider -ProviderNamespace Microsoft.HybridCompute
Register-AzResourceProvider -ProviderNamespace Microsoft.GuestConfiguration
