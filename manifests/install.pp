class autoupdate::install {
  # The base class must be included first
  if !defined(Class['autoupdate']) {
    fail('You must include the autoupdate base class before using any autoupdate sub class')
  }

  # package installation and service configuration
  package { 'yum-cron': ensure => present } ->
  service { 'yum-cron':
    ensure => $::autoupdate::service_ensure,
    enable => $::autoupdate::service_enable
  }
}
