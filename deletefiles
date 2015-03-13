### Show Files

$path = "C:\inetpub\logs\LogFiles\W3SVC1" 
$Include=@("*.log")
$cntDate = (get-date).AddDays(-7)
 

Get-ChildItem -Path $path -recurse -include "$Include" | where {$_.CreationTime -lt $cntDate}


### Delete Files

$path = "C:\inetpub\logs\LogFiles\W3SVC1" 
$Include=@("*.log")
$cntDate = (get-date).AddDays(-10)
 

Get-ChildItem -Path $path -recurse -include "$Include" | % {
	if ($_.CreationTime -lt $cntDate){
		$file = $path + "\" +$_.name
		Remove-Item $file
		$file
	}
}
