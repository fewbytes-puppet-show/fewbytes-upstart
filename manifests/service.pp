# Setting up an upstart service
define upstart::service(
  $service_name=$title,
  $ensure=running,
  $enable=true,
  $user=undef,
  $group=undef,
  $chdir=undef,
  $chroot=undef,
  $exec=undef,
  $script=undef,
  $expect=undef,
  $start_on='runlevel [2345]',
  $stop_on='runlevel [^2345]',
  $template='upstart/init.conf.erb',
  $env={},
  $limits={},
  $nice=undef,
  $respawn=false,
  $respawn_limit=undef,
  $hooks={}
) {
  include upstart::params
  include upstart::utils

  if($respawn_limit!=undef){
    validate_string($respawn_limit)
  }
  validate_bool($respawn)

  file{"${upstart::params::svc_dir}/${service_name}.conf":
    content => template($template),
    mode    => '0644',
    notify  => Service[$service_name]
  } ->

  file{"${upstart::params::svc_dir}.d/${service_name}":
    ensure => link,
    target => "${upstart::params::svc_dir}/${service_name}.conf"
  }

  case $::osfamily {
    'RedHat' : {
      service { $service_name:
        ensure     => $ensure,
        hasrestart => true,
        hasstatus  => true,
        start      => "/sbin/initctl start ${service_name}",
        restart    => "/sbin/initctl stop ${service_name}; /sbin/initctl start ${service_name}",
        stop       => "/sbin/initctl stop ${service_name}",
        status     => "/sbin/initctl status ${service_name} | grep running",
        require    => [File["${upstart::params::svc_dir}/${service_name}.conf"],
                        File['/usr/local/sbin/chpst.py']]
      }
    }
    'Debian' : {
      service { $service_name:
        ensure  => $ensure,
        require => File["${upstart::params::svc_dir}/${service_name}.conf"]
      }
    }
    default: {
      fail('This platform is not supported')
    }
  }
}
