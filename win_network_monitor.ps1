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

	Get-Date *> sample-$hour-$min.txt
	Get-NetAdapter *>> sample-$hour-$min.txt
	Get-NetIPConfiguration *>> sample-$hour-$min.txt
	Test-NetConnection www.google.com *>> sample-$hour-$min.txt
	Test-NetConnection api.truesight.bmc.com *>> sample-$hour-$min.txt

	$min = $min + 15

	# Sleep for 15 mins
	Start-Sleep -s 900
}
