# == Class: autoupdate
#
# This module installs yum-cron on Enterprise Linux systems and configures nightly system updates.
#
# === Parameters:
#
# [*action*]
#   mode in which yum-crom should perform (valid: 'check'|'download'|'apply')
# [*exclude*]
#   array of packages to exclude from automatic update
# [*service_enable*]
#   enable service or not (valid: true|false)
# [*service_ensure*]
#   whether the service should be running (valid: 'stopped'|'running')
# [*notify_email*]
#   enable email notifications (valid: true|false)
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
#   what kind of update to use (valid: default, security, security-severity:Critical, minimal, minimal-security, minimal-security-severity:Critical)
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
#  class { '::autoupdate':
#    email   => 'user@example.com',
#    exclude => ['kernel']
#  }
#
class autoupdate (
  $action         = 'apply',
  $exclude        = [],
  $service_enable = true,
  $service_ensure = 'running',
  $notify_email   = true,
  $email_to       = 'root',
  $email_from     = 'root',
  $debug_level    = $::autoupdate::params::debug_level,
  $error_level    = 0,
  $update_cmd     = 'default',
  $randomwait     = 60) inherits ::autoupdate::params {
  # parameters validation
  validate_re($action, '^(check|download|apply)$', '$action must be either \'check\', \'download\' or \'apply\'')
  validate_array($exclude)
  validate_bool($service_enable, $notify_email)
  validate_re($service_ensure, '^(stopped|running)$', '$service_ensure must be either \'stopped\', or \'running\'')
  validate_string($email_to, $email_from, $update_cmd)
  validate_re($debug_level, '^([0-9]|10|-1)$', '$debug_level must be a number between -1 and 10')
  validate_re($error_level, '^([0-9]|10)$', '$error_level must be a number between 0 and 10')
  validate_re($update_cmd, '^(default|security|security-severity:Critical|minimal|minimal-security|minimal-security-severity:Critical)$',
    '$update_cmd must be either \'default\', \'security\', \'security-severity:Critical\', \'minimal\', \'minimal-security\' or \'minimal-security-severity:Critical\'')
  validate_re($randomwait, '^([0-9]|[1-9][0-9]|[1-9][0-9][0-9]|1[0-3][0-9][0-9]|14[0-3][0-9]|1440)$', '$randomwait must be a number between 0 and 1440')

  # set real parameter values
  $debug_level_real = $notify_email ? {
    false   => '-1',
    default => $debug_level,
  }

  # platform specific logic
  if ($::operatingsystem == 'Fedora' and $::operatingsystemmajrelease =~ /1[5-8]/) or ($::operatingsystemmajrelease =~ /5|6/) {
    $exclude_real = join(prefix($exclude, '--exclude='), '\ ')
  } else {
    $exclude_real = join($exclude, ' ')
  }

  # perform the actions
  include ::autoupdate::install
  include ::autoupdate::files
  Class['::autoupdate::install'] -> Class ['::autoupdate::files']
}