# === Class: autoupdate
#
# This module installs yum-cron on CentOS systems and configures nightly system updates.
#
# == Parameters
#
# $action:
#   mode in which yum-crom should perform (valid: 'check'|'download'|'apply')
# $exclude:
#   array of packages to exclude from automatic update
# $service_enable:
#   enable service or not (valid: true|false)
# $service_ensure:
#   whether the service should be running (valid: 'stopped'|'running')
# $email_to:
#   recipient email address for update notifications
# $email_from:
#   sender email address for update notifications. No effect when $email_to is empty
# $error_level:
#   YUM error level (valid: 0-10). 0 to disable
# $debug_level:
#   YUM debug level (valid: 0-10). 0 to disable
# $randomwait
#   maximum amount of time in minutes YUM randomly waits before running (valid: 0-1440). 0 to disable
#
# === Actions
#
# - Install yum-cron
# - Configure automatic updates and email notifications
#
# === Requires
#
# (none)
#
# === Sample Usage:
#
# class { '::autoupdate':
#   email   => 'user@example.com',
#   exclude => ['kernel']
# }
#
class autoupdate (
  $action         = 'apply',
  $exclude        = [],
  $service_enable = true,
  $service_ensure = 'running',
  $email_to       = 'root',
  $email_from     = 'root',
  $download_only  = 'no',
  $error_level    = 0,
  $debug_level    = 0,
  $randomwait     = 60) inherits ::autoupdate::params {
  # parameters validation
  validate_re($action, '^(check|download|apply)$', '$action must be either \'check\', \'download\' or \'apply\'')
  validate_array($exclude)
  validate_bool($service_enable)
  validate_re($service_ensure, '^(stopped|running)$', '$service_ensure must be either \'stopped\', or \'running\'')
  validate_string($email_to, $email_from)
  validate_re($error_level, '^([0-9]|10)$', '$error_level must be a number between 0 and 10')
  validate_re($debug_level, '^([0-9]|10)$', '$debug_level must be a number between 0 and 10')
  validate_re($randomwait, '^([0-9]|[1-9][0-9]|[1-9][0-9][0-9]|1[0-3][0-9][0-9]|14[0-3][0-9]|1440)$', '$randomwait must be a number between 0 and 1440')

  # package installation
  package { 'yum-cron': ensure => present } ->
  service { 'yum-cron':
    ensure => $service_ensure,
    enable => $service_enable
  }

  # config file
  file { 'yum-cron config':
    ensure  => present,
    path    => $::autoupdate::params::config_file,
    content => template("autoupdate/yum-cron-conf-rhel${::operatingsystemmajrelease}.erb")
  }

  # the yum-cron script itself might need to be overriden in order to implement the extra options provided by this module
  if $::autoupdate::params::custom_script == true {
    file { 'yum-cron script':
      ensure  => present,
      path    => $::autoupdate::params::script_path,
      content => template("autoupdate/yum-cron-script-rhel${::operatingsystemmajrelease}.erb"),
      mode    => '0755'
    }
  }
}
