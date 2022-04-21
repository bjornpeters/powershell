function Add-ScriptExtension {
    param (
        [parameter(Mandatory = $true,
            HelpMessage = "Provide a string with the name of the Azure VM.")]
        [ValidateNotNullOrEmpty()]
        [string]$FileUri,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a string with the name of the Azure VM.")]
        [ValidateNotNullOrEmpty()]
        [string]$VMName,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a string with the name of the Azure VM.")]
        [ValidateNotNullOrEmpty()]
        [string]$Script,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a string with the name of the Azure VM.")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a string with the name of the Azure VM.")]
        [ValidateNotNullOrEmpty()]
        [string]$LocationName
    )

    Set-AzVMCustomScriptExtension -ResourceGroupName $ResourceGroupName `
    -VMName $VMName `
    -Location $LocationName `
    -FileUri $FileUri `
    -Run  $Script`
    -Name EnablePSRemoting
    
}

function New-TestLabVM {
    param (
        [parameter(Mandatory = $true,
            HelpMessage = "Provide a string with the name of the Azure VM.")]
        [ValidateNotNullOrEmpty()]
        [string]$VMName,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a string with the name of the Azure VM.")]
        [ValidateNotNullOrEmpty()]
        [string]$VMSize,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a string with the name of the Azure VM.")]
        [ValidateNotNullOrEmpty()]
        [pscredential]$Credential,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a valid array object.")]
        [ValidateNotNullOrEmpty()]
        [string]$NICID,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a valid array object.")]
        [ValidateNotNullOrEmpty()]
        [string]$Skus,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a valid array object.")]
        [ValidateNotNullOrEmpty()]
        [string]$Offer,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a valid array object.")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [parameter(Mandatory = $true,
            HelpMessage = "Provide a valid array object.")]
        [ValidateNotNullOrEmpty()]
        [string]$LocationName
    )

    $VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
    $VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $VMName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
    $VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
    $VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName $publisherName -Offer $Offer -Skus $Skus -Version latest
    New-AzVm -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine
    
}