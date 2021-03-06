$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

$hour = 0
$min = 0
$googles_failures = 0
$google_failures = 0
$bmc_failures = 0

while(1) {

	netsh winhttp show proxy

	if ($hour -eq 12 -Or $hour -eq 24) {
		..\..\truesight_utils.exe send_event -t "BMC http failures - $bmc_failures" -s info
		..\..\truesight_utils.exe send_event -t "Test https failures - $googles_failures" -s info
		..\..\truesight_utils.exe send_event -t "Test http failures - $google_failures" -s info
		$googles_failures = 0
		$google_failures = 0
		$bmc_failures = 0
	}

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
	iwr -Method HEAD -UseBasicParsing https://api.truesight.bmc.com > api-$hour-$min.txt
	if (-not $?) {
		$bmc_failures = $bmc_failures + 1
	}
	iwr -Method HEAD -UseBasicParsing https://www.google.com > googles-$hour-$min.txt
	if (-not $?) {
		$googles_failures = $googles_failures + 1
	}
	iwr -Method HEAD -UseBasicParsing http://www.google.com > google-$hour-$min.txt
	if (-not $?) {
		$google_failures = $google_failures + 1
	}

	$min = $min + 15

	# Sleep for 15 mins
	Start-Sleep -s 900
}
