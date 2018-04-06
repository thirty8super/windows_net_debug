$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

$hour = 0
$min = 0

while(1) {

	if ($hour -eq 24) {
		$hour = 0
	}

	if ($min -eq 60) {
		$hour = $hour + 1
		$min = 0
	}

	Get-Date | Out-File  sample-$hour-$min.txt
	Get-NetAdapter | Out-File -Append sample-$hour-$min.txt
	Get-NetIPConfiguration | Out-File -Append sample-$hour-$min.txt
	Test-NetConnection www.google.com | Out-File -Append sample-$hour-$min.txt
	Test-NetConnection api.truesight.bmc.com | Out-File -Append sample-$hour-$min.txt
	Test-NetConnection status.truesight.bmc.com | Out-File -Append sample-$hour-$min.txt
	iwr -Method HEAD https://api.truesight.bmc.com > api-$hour-$min.txt
	iwr -Method HEAD https://help.truesight.bmc.com > help-$hour-$min.txt

	$min = $min + 15

	# Sleep for 15 mins
	Start-Sleep -s 900
}
