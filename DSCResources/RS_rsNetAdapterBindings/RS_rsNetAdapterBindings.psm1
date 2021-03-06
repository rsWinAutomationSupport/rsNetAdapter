function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,
        
        [parameter(Mandatory = $true)]
		[System.String]
		$Adapter,

        [ValidateSet("ms_rspndr","ms_lltdio","ms_implat","ms_msclient","ms_pacer","ms_server","ms_tcpip6","ms_tcpip")]
		[System.String]
		$ComponentID,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."
 
    	$Configuration = @{
        Name = $Name
        Ensure = $Ensure
        Adapter = $Adapter
        ComponentID = $ComponentID
        }
    return $Configuration

	<#
	$returnValue = @{
		Adapter = [System.String]
		ComponentID = [System.String]
		Ensure = [System.String]
	}

	$returnValue
	#>
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
        
        [parameter(Mandatory = $true)]
		[System.String]
		$Name,
        
		[parameter(Mandatory = $true)]
		[System.String]
		$Adapter,

		[ValidateSet("ms_rspndr","ms_lltdio","ms_implat","ms_msclient","ms_pacer","ms_server","ms_tcpip6","ms_tcpip")]
		[System.String]
		$ComponentID,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)
    
    
	if ($Ensure -like "Present"){Enable-NetAdapterBinding -Name $Adapter -ComponentID $ComponentID}
	else {Disable-NetAdapterBinding -Name $Adapter -ComponentID $ComponentID}
    
    
	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

	#Include this line if the resource requires a system reboot.
	#$global:DSCMachineStatus = 1


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
        [parameter(Mandatory = $true)]
		[System.String]
		$Name,
        
		[parameter(Mandatory = $true)]
		[System.String]
		$Adapter,

		[ValidateSet("ms_rspndr","ms_lltdio","ms_implat","ms_msclient","ms_pacer","ms_server","ms_tcpip6","ms_tcpip")]
		[System.String]
		$ComponentID,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	<#
	$result = [System.Boolean]
	
	$result
	#>
    $IsValid = $false
    if($Ensure -like "Present"){
        if((Get-NetAdapterBinding -Name $Adapter|Where-Object {$_.ComponentID -like $ComponentID}).Enabled -like "True") {
            $IsValid = $true }
    }
    else{if((Get-NetAdapterBinding -Name $Adapter|Where-Object {$_.ComponentID -like $ComponentID}).Enabled -like "True"){}
        else{$IsValid = $true}
    }


    return $IsValid
}


Export-ModuleMember -Function *-TargetResource

