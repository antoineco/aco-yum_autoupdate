class yum_autoupdate::install {
  # The base class must be included first
  if !defined(Class['yum_autoupdate']) {
    fail('You must include the yum_autoupdate base class before using any yum_autoupdate sub class')
  }

  # package installation and service configuration
  package { 'yum-cron': ensure => present } ->
  service { 'yum-cron':
    ensure => $::yum_autoupdate::service_ensure,
    enable => $::yum_autoupdate::service_enable
  }
}
