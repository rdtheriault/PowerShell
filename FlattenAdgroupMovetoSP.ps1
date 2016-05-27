#Function to flatten Ad Groups passes $user global and 
Function FlattenADGroup ($global:users, $groupHolder){

    Get-ADGroupMember -identity $groupHolder | ForEach-Object {

        if ($_.objectClass -eq "group") {FlattenADGroup $global:users $_.SamAccountName}
        elseif ($_.objectClass -eq "user") {
            $test = Get-ADUser -identity $_.SamAccountName -Properties "EmployeeID"  #test to see if this is a real person with emp #
            if ($test.EmployeeID -ne $Null){
                $global:users += $_.SamAccountName
            }
        }
    }
}


Function UpdateShadowGroup ($global:users, $groupName){

    #get shadow group name
    $name = get-ADGroup -identity $groupName; $name = get-ADGroup -filter {description -like $name.samaccountname}; $name = $name.samaccountname

    #Add new shadowgroup members
    $global:users | ForEach {Write-Host $_ "name into " $name} #Add-ADGroupMember -Identity $name -Members $_

    #Get shadowgroup members
    $shadowNames = @(); Get-ADGroupMember -identity $name | ForEach-Object {$shadowNames += $_.samaccountname}
    #delete old shadowgroup members
    $shadowNames | ForEach-Object {if($global.user -notcontains $_){Remove-ADGroupMember -identity $name -members $_}}

}

#Function to add members to SP, does not current remove
Function AdToSp ($global:users $groupHolder){

	$web = Get-SPWeb https://share.site

	#get shadow group name
	$name = get-ADGroup -identity $groupHolder; $name = get-ADGroup -filter {description -like $name.samaccountname}; $name = $name.samaccountname

	$SPGroup = $web.SiteGroups[$name] 
 
	$global:users | ForEach-Object {
	   
        	#Add the member to ther associated SharePoint Group
        	$userName = $_.samaccountname        
        	$web.EnsureUser($userName)  |  Set-SPUser -Web $web -Group $SPGroup
    }

	$web.Dispose()
}



Add-PSSnapin Microsoft.SharePoint.PowerShell
Import-Module ActiveDirectory

#variables
$groupNameHolders = @();$shadowHolder = @();$global:users = @()

#Get Shadow AD groups with "SharePoint Groups" as an OU the pull the AD groups correlation out of the descritption => the -properties lets you select extra outputs
Get-ADGroup -Filter '*' -Properties "Description" -SearchBase "OU=Sharepoint Groups,ou=groups,DC=domain,dc=local" | ForEach-Object {

    #will end up needing to split on ;
    $test = $_.Description                           
    if ($test -ne $null) {$groupNameHolders += $test} #if contains ";"
}

$groupNameHolders | ForEach-Object {
    FlattenADGroup $global:users $_
    UpdateShadowGroup $global:users $_
    AdToSp $global:users $_
    $global:users = @() #reset users for next group
}
    
