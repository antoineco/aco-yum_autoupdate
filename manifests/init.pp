# == Class: yum_autoupdate
#
# This module installs yum-cron on Enterprise Linux systems and configures nightly system updates.
#
# === Parameters:
#
# [*service_enable*]
#   enable service (boolean)
# [*service_ensure*]
#   whether the service should be running (valid: 'stopped'|'running')
# [*default_schedule*]
#
# [*default_hourly*]
#
# [*action*]
#   mode in which yum-crom should perform (valid: 'check'|'download'|'apply')
# [*exclude*]
#   packages to exclude from automatic update (array)
# [*notify_email*]
#   enable email notifications (boolean)
# [*email_to*]
#   recipient email address for update notifications. No effect when $notify is false
# [*email_from*]
#   sender email address for update notifications. No effect when $email_to is empty
# [*debug_level*]
#   YUM debug level (valid: 0-10 or -1). -1 to disable debug output completely
# [*error_level*]
#   YUM error level (valid: 0-10). 0 to disable error output completely
# [*randomwait*]
#   maximum amount of time in minutes YUM randomly waits before running (valid: 0-1440). 0 to disable
# [*update_cmd*]
#   what kind of update to use (valid: default, security, security-severity:Critical, minimal, minimal-security,
#   minimal-security-severity:Critical)
#
# === Actions:
#
# * Install yum-cron
# * Configure automatic updates and email notifications
#
# === Requires:
#
# - puppetlabs/stdlib module
#
# === Sample Usage:
#
#  class { '::yum_autoupdate':
#    email   => 'user@example.com',
#    exclude => ['kernel']
#  }
#
class yum_autoupdate (
  $service_enable   = true,
  $service_ensure   = 'running',
  $default_schedule = true,
  $default_hourly   = false,
  $action           = 'apply',
  $exclude          = [],
  $notify_email     = true,
  $email_to         = 'root',
  $email_from       = 'root',
  $debug_level      = $yum_autoupdate::params::debug_level,
  $error_level      = 0,
  $update_cmd       = 'default',
  $randomwait       = 60) inherits yum_autoupdate::params {
  # parameters validation
  validate_re($action, '^(check|download|apply)$', '$action must be either \'check\', \'download\' or \'apply\'')
  validate_array($exclude)
  validate_bool($service_enable, $notify_email)
  validate_re($service_ensure, '^(stopped|running)$', '$service_ensure must be either \'stopped\', or \'running\'')
  validate_string($email_to, $email_from, $update_cmd)
  if ($debug_level < -1) or ($error_level > 10) { fail('$debug_level must be a number between -1 and 10') }
  if ($error_level < 0) or ($error_level > 10) { fail('$error_level must be a number between 0 and 10') }
  validate_re($update_cmd, '^(default|security|security-severity:Critical|minimal|minimal-security|minimal-security-severity:Critical)$', '$update_cmd must be either \'default\', \'security\', \'security-severity:Critical\', \'minimal\', \'minimal-security\' or \'minimal-security-severity:Critical\'')
  if ($randomwait < 0) or ($randomwait > 1440) { fail('$randomwait must be a number between 0 and 1440') }

  # set real parameter values
  $debug_level_real = $notify_email ? {
    false   => '-1',
    default => $debug_level,
  }

  if ($::operatingsystem == 'Fedora' and $::operatingsystemmajrelease < 19) or ($::operatingsystem != 'Fedora' and $::operatingsystemmajrelease < 7) {
    $exclude_real = join(prefix($exclude, '--exclude='), '\ ')
  } else {
    $exclude_real = join($exclude, ' ')
  }

  # package installation and service configuration
  package { 'yum-cron': ensure => present } ->
  service { 'yum-cron':
    ensure => $service_ensure,
    enable => $service_enable
  }

  # don't attempt any file replacement before the package is installed
  File {
    require => Package['yum-cron'],
    owner   => 'root',
    group   => 'root'
  }

  # create a more suitable location for our scripts
  file { '/etc/yum/schedules': ensure => directory }

  # on Fedora 17 and 18, edit the script in place
  if $::operatingsystem == 'Fedora' and $::operatingsystemmajrelease < 19 {
    file { 'yum-cron script':
      ensure  => present,
      path    => '/usr/sbin/yum-cron',
      content => template("${module_name}/script/fc17.erb"),
      mode    => '0755'
    }
  }

  # config file
  # Template uses:
  # - 
  if $default_schedule {
    file { 'yum-cron default config':
      ensure  => present,
      path    => $yum_autoupdate::params::config_path,
      content => template("${module_name}/conf/${yum_autoupdate::params::conf_tpl}"),
      mode    => '0644'
    }
  } else {
    file { 'yum-cron default config':
      ensure => absent,
      path   => $yum_autoupdate::params::config_path
    }
  }

  # default daily schedule
  # Template uses:
  # - 
  if $default_schedule {
    file { 'yum-cron default schedule':
      ensure  => present,
      path    => $yum_autoupdate::params::default_schedule_path,
      content => template("${module_name}/schedule/${yum_autoupdate::params::schedule_tpl}"),
      mode    => '0755'
    }
  } else {
    file { 'yum-cron default schedule':
      ensure => absent,
      path   => $yum_autoupdate::params::default_schedule_path
    }
  }

  # clear default hourly schedule on more recent OSes
  # it can be recreated and customized using a 'schedule' resource
  if ($::operatingsystem == 'Fedora' and $::operatingsystemmajrelease >= 19) or ($::operatingsystemmajrelease >= 7) {
    unless $default_hourly {
      file { ['/etc/yum/yum-cron-hourly.conf', '/etc/cron.hourly/0yum-hourly.cron']: ensure => absent }
    }
  }
}