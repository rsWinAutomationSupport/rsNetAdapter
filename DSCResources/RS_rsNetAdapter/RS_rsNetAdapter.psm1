## Rackconnected V2 devices that reside in the default region will override the $NAME value to ensure "UNUSED" and "PRIVATE" names are used and the "UNUSED" interface is disabled.

Function Get-TargetResource {
   param (
      [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$InterfaceDescription,
      [string]$Name,
      [bool]$Logging
   )
   if((Get-NetAdapter | ? InterfaceDescription -eq $InterfaceDescription)) { $InterfaceDescription = $InterfaceDescription } else { $InterfaceDescription = "Interface not found" }
   @{
  InterfaceDescription = $InterfaceDescription
  Name = (Get-NetAdapter | ? InterfaceDescription -eq $InterfaceDescription).Name
  Logging = $Logging
  }
}

Function Test-TargetResource {
   param (
      [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$InterfaceDescription,
      [string]$Name,
      [bool]$Logging
   )
   $logSource = $PSCmdlet.MyInvocation.MyCommand.ModuleName
   New-EventLog -LogName "DevOps" -Source $logSource -ErrorAction SilentlyContinue
   $base = gwmi -n root\wmi -cl CitrixXenStoreBase
   $sid = $base.AddSession("MyNewSession")
   $session = gwmi -n root\wmi -q "select * from CitrixXenStoreSession where SessionId=$($sid.SessionId)"
   $region = $session.GetValue("vm-data/provider_data/region").value -replace "`"", ""
   try {
      $Rackconnected = (Invoke-RestMethod -Uri $(("https://", $region -join ''), ".api.rackconnect.rackspace.com/v1/automation_status?format=text" -join '') -Method Get)
      if($Rackconnected.count -gt 0) {
         $isRackconnected = $true
      }
      else {
         $isRackconnected = $false
      }
   }
   catch {
      $isRackconnected = $false
   }
   if($isRackconnected = $true) { 
      if($Logging) {
         Write-EventLog -LogName DevOps -Source $logSource -EntryType Information -EventId 1000 -Message "Test-TargetResource: Server is Rackconnect v2"
      }
      if($InterfaceDescription = "Citrix PV Network Adapter #0") {
         $nicName = "Unused" 
      }
      if($InterfaceDescription = "Citrix PV Network Adapter #1") {
         $nicName = "Private" 
      }
   } 
   else { 
      $nicName = $Name 
   } 
   if((Get-NetAdapter | ? InterfaceDescription -eq $InterfaceDescription).Name -eq $nicName) {
      if($Logging) {
         Write-EventLog -LogName DevOps -Source $logSource -EntryType Information -EventId 1000 -Message "$InterfaceDescription is properly named with $nicName"
      }
      return $true
   }
   else {
      if($Logging) {
         Write-EventLog -LogName DevOps -Source $logSource -EntryType Information -EventId 1000 -Message "$InterfaceDescription is not properly named with $nicName"
      }
      return $false
   }
}

Function Set-TargetResource {
   param (
      [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$InterfaceDescription,
      [string]$Name,
      [bool]$Logging
   )
   $logSource = $PSCmdlet.MyInvocation.MyCommand.ModuleName
   New-EventLog -LogName "DevOps" -Source $logSource -ErrorAction SilentlyContinue
   $base = gwmi -n root\wmi -cl CitrixXenStoreBase
   $sid = $base.AddSession("MyNewSession")
   $session = gwmi -n root\wmi -q "select * from CitrixXenStoreSession where SessionId=$($sid.SessionId)"
   $region = $session.GetValue("vm-data/provider_data/region").value -replace "`"", ""
   try {
      $Rackconnected = (Invoke-RestMethod -Uri $(("https://", $region -join ''), ".api.rackconnect.rackspace.com/v1/automation_status?format=text" -join '') -Method Get)
      if($Rackconnected.count -gt 0) {
         $isRackconnected = $true
      }
      else {
         $isRackconnected = $false
      }
   }
   catch {
      $isRackconnected = $false
   }
   if($isRackconnected = $true) { 
      if($Logging) {
         Write-EventLog -LogName DevOps -Source $logSource -EntryType Information -EventId 1000 -Message "Set-TargetResource: Server is Rackconnect v2"
      }
      if($InterfaceDescription = "Citrix PV Network Adapter #0") {
         $nicName = "Unused"
         if($Logging) {
            Write-EventLog -LogName DevOps -Source $logSource -EntryType Information -EventId 1000 -Message "ReNaming $InterfaceDescription with name $nicName and setting to disabled"
         }
         Get-NetAdapter | ? InterfaceDescription -eq $InterfaceDescription | Rename-NetAdapter -NewName $nicName
         Disable-NetAdapter -Name $nicName 
      }
      if($InterfaceDescription = "Citrix PV Network Adapter #1") {
         $nicName = "Private" 
         if($Logging) {
            Write-EventLog -LogName DevOps -Source $logSource -EntryType Information -EventId 1000 -Message "ReNaming $InterfaceDescription with name $nicName"
         }
         Get-NetAdapter | ? InterfaceDescription -eq $InterfaceDescription | Rename-NetAdapter -NewName $nicName
      }
   } 
   else { 
      if($Logging) {
         Write-EventLog -LogName DevOps -Source $logSource -EntryType Information -EventId 1000 -Message "ReNaming $InterfaceDescription with name $Name"
      }
      Get-NetAdapter | ? InterfaceDescription -eq $InterfaceDescription | Rename-NetAdapter -NewName $Name
   } 
}
Export-ModuleMember -Function *-TargetResource