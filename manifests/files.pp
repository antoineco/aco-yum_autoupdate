class yum_autoupdate::files {
  # The base class must be included first
  if !defined(Class['yum_autoupdate']) {
    fail('You must include the yum_autoupdate base class before using any yum_autoupdate sub class')
  }

  # config file
  file { 'yum-cron config':
    ensure  => present,
    path    => $::yum_autoupdate::params::config_path,
    content => template("yum_autoupdate/${::yum_autoupdate::params::config_tpl}"),
    mode    => '0644',
    owner   => 'root',
    group   => 'root'
  }

  # the yum-cron script itself might need to be overriden in order to implement the extra options provided by this module
  if $::yum_autoupdate::params::custom_script == true {
    file { 'yum-cron script':
      ensure  => present,
      path    => $::yum_autoupdate::params::script_path,
      content => template("yum_autoupdate/${::yum_autoupdate::params::script_tpl}"),
      mode    => '0755',
      owner   => 'root',
      group   => 'root'
    }
  }

  # temporary!
  # we don't need these, the user will have the option to add schedules in a future version
  file { ['/etc/yum/yum-cron-hourly.conf', '/etc/cron.hourly/0yum-hourly.cron']: ensure => absent }
}