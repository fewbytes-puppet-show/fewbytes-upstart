class upstart::params {
	$svc_dir = "/etc/init"
	case $::operatingsystem {
		RedHat, CentOs: {
			if versioncmp($::operatingsystemrelease, "6.0") < 0 {
				fail("This platform/version combo is not supported for upstart")
			} else {
				$setuid_supported = false
				$setgid_supported = false
			}
		}
		Ubuntu: {
			if versioncmp($::operatingsystemrelease, "12.04") < 0 {
				$setuid_supported = false
				$setgid_supported = false				
			} else {
				$setuid_supported = true
				$setgid_supported = true
			}
		}
		default: {
			fail("This platform/version combo is not supported for upstart")
		}
	}
}