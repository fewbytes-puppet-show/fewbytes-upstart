define upstart::service(
	$service_name=$title,
	$ensure=running,
	$user=undef,
	$group=undef,
	$chdir=undef,
	$exec=undef,
	$script=undef,
	$type=foreground,
	$template="upstart/init.conf.erb"
) {
	include upstart::params
	include upstart::utils
	
	file{"${upstart::params::svc_dir}/${service_name}.conf":
		content => template($template),
		mode => 644
	}
	
	case $::osfamily {
		"RedHat" : {
			service { $service_name:
				ensure => $ensure,
				hasrestart => true,
				hasstatus => true,
				start => "/sbin/initctl start ${service_name}",
				stop => "/sbin/initctl stop ${service_name}",
				status => "/sbin/initctl status ${service_name} | grep running",
				require => [File["${upstart::params::svc_dir}/${service_name}.conf"],
					File["/usr/local/sbin/chpst.py"]]	
			}
		}
		"Debian" : {
			service { $service_name:
				ensure => $ensure,
				require => File["${upstart::params::svc_dir}/${service_name}.conf"]
			}
		}
	}
}