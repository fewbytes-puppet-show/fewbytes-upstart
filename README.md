# upstart puppet module

## Usage
To create an upstart service use the `upstart::service` definition:

	upstart::service{"redis-server":
		exec => "/usr/bin/redis-server /etc/redis/redis.conf",
		user => "redis",
		group => "redis",
		limits => {"nofile" => 65536},
		chdir => "/var/lib/redis",
	}

### Definition parameters
You must supply at least `exec` or `script`. See below for what those parameters mean.

service_name - The name of the service. The default value for this is $title
enable - Whether to enable or disable this service. Default is true
ensure - This will be passed as is to the underlying `service` resource.
exec - The command to execute
script - Run this script instead of executing a command
expect - What kind of process should upstart expect. Allowed values are (on upstart 0.6.x) `stop`, `fork`, `daemon`. Check the upstart documentation for details.
start_on - Events to start on. Defaults to `runlevel [2345]`, check the upstart docs for allowed values.
stop_on - Events to stop on. Defaults to `runlevel [^2345]`, check the upstart docs for allowed values.
user - User to chuid to
group - Group to chguid to
chdir - A directory to chdir to
chroot - chroot to directory before running the process
nice - Process nice level (priority)

## License

GPL v3

## Support

Please log tickets and issues at our [Projects site](https://github.com/fewbytes-puppet-show/fewbytes-upstart)
