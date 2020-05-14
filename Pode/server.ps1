#Start Pode Server
Start-PodeServer {

    #Attach port 8000 to the local machine address and use HTTP protocol
    Add-PodeEndpoint -Address localhost -Port 8000 -Protocol HTTP

    #Create route and return a static value
    Add-PodeRoute -Method Get -Path '/static' -ScriptBlock {
        Write-PodeJsonResponse -Value @{ 'value' = 'My first API response!' }
    }

    #Create route and give a random number as response
    Add-PodeRoute -Method Get -Path '/dynamic' -ScriptBlock {           
        
        #Generate random number and store it into a custom object
        $random = Get-Random -Minimum 1 -Maximum 30
        $object = New-Object -TypeName PSCustomObject
        $object | Add-Member -MemberType NoteProperty -Name Number -Value $random
        
        #Get the custom object and convert it to JSON
        $response = $object | ConvertTo-Json 
        Write-PodeJsonResponse -Value $response
    }
}