
$source = $env:computername

while(1) {
	Get-NetAdapter *>> sample.txt
	Get-NetIPConfiguration *>> sample.txt
	Test-NetConnection www.google.com *>> sample.txt
	Test-NetConnection api.truesight.bmc.com *>> sample.txt

	$message = Get-Content sample.txt -raw

	..\..\truesight-utils.exe -t "Network Sample on $env:computername" -s info -m $message

	# Clean the file
	rm sample.txt

	# Sleep for 15 mins
	Start-Sleep -s 900
}
