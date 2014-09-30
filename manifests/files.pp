class autoupdate::files {
  # The base class must be included first
  if !defined(Class['autoupdate']) {
    fail('You must include the autoupdate base class before using any autoupdate sub class')
  }

  # config file
  file { 'yum-cron config':
    ensure  => present,
    path    => $::autoupdate::params::config_path,
    content => template("autoupdate/${::autoupdate::params::config_tpl}"),
    mode    => '0644',
    owner   => 'root',
    group   => 'root'
  }

  # the yum-cron script itself might need to be overriden in order to implement the extra options provided by this module
  if $::autoupdate::params::custom_script == true {
    file { 'yum-cron script':
      ensure  => present,
      path    => $::autoupdate::params::script_path,
      content => template("autoupdate/${::autoupdate::params::script_tpl}"),
      mode    => '0755',
      owner   => 'root',
      group   => 'root'
    }
  }

  # temporary!
  # we don't need these, the user will have the option to add schedules in a future version
  file { ['/etc/yum/yum-cron-hourly.conf', '/etc/cron.hourly/0yum-hourly.cron']: ensure => absent }
}