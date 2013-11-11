function Get-BinRoot {

	# Since CamelCase was decided upon when $env:ChocolateyInstall was first invented, whe should stick to this convention and use $env:ChocolateyBinRoot.
	# I propose: 
	#    1) all occurances of $env:chocolatey_bin_root be replaced with $env:ChocolateyBinRoot;
	#    2) Make the new Chocolatey Installer for new users explicitly set (if not exists) $env:ChocolateyInstall and $env:ChocolateyBinRoot as environment variables so users will smile and understand;
	#    3) Make new Chocolatey convert old $env:chocolatey_bin_root to $env:ChocolateyBinRoot
	
	# For now, check old var first
	if($env:ChocolateyBinRoot -eq $null) { # If no value
		if($env:chocolatey_bin_root -eq $null) { # Try old var
			$binRoot = "$env:ChocolateyInstall\bin"
		}
		else {
			$env:ChocolateyBinRoot = $env:chocolatey_bin_root
		}
	}

	# My ChocolateyBinRoot is C:\Common\bin, but looking at other packages, not everyone assumes ChocolateyBinRoot is prepended with a drive letter.
	if (-not($env:ChocolateyBinRoot -imatch "^\w:")) {
		# Add drive letter
		$binRoot = join-path $env:systemdrive $env:ChocolateyBinRoot
	}
	else {
		$binRoot = $env:ChocolateyBinRoot
	}
	
	# Now that we figured out the binRoot, let's store it as per proposal #3 line #7
	if(-not($env:ChocolateyBinRoot -eq $binRoot)) {
		[Environment]::SetEnvironmentVariable("ChocolateyBinRoot", "$binRoot", "User")
		# Note that user variables pose a problem when there are two admins on one computer. But this is what was decided upon.
	}
	
	return $binRoot
}
