define upstart::service(
	$service_name=$title,
	$ensure=running,
	$enable=true,
	$user=undef,
	$group=undef,
	$chdir=undef,
	$exec=undef,
	$script=undef,
	$expect=undef,
	$start_on="runlevel [2345]",
	$stop_on="runlevel [^2345]",
	$template="upstart/init.conf.erb",
	$env={}
) {
	include upstart::params
	include upstart::utils

	file{"${upstart::params::svc_dir}/${service_name}.conf":
		ensure => $enable ? { true => present, false => absent, default => present},
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