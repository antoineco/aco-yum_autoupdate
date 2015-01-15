# == Class: yum_autoupdate::params
#
class yum_autoupdate::params {
  case $::osfamily {
    'RedHat' : {
      case $::operatingsystem {
        'Fedora' : {
          case $::operatingsystemmajrelease {
            /^(19|20|21)$/ : {
              $config_path = '/etc/yum/yum-cron.conf'
              $conf_tpl = 'rhel7.erb'
              $schedule_tpl = 'rhel7.erb'
              $debug_level = '-1'
              $default_schedule_path = '/etc/cron.daily/0yum-daily.cron'
            }
            /^(17|18)$/    : {
              $config_path = '/etc/sysconfig/yum-cron'
              $conf_tpl = 'rhel6.erb'
              $schedule_tpl = 'fc17.erb'
              $debug_level = 1
              $default_schedule_path = '/etc/cron.daily/0yum-update'
            }
            default        : {
              fail("Unsupported OS version ${::operatingsystemmajrelease}")
            }
          }
        }
        # all other RHEL-based OS
        default  : {
          case $::operatingsystemmajrelease {
            '7'     : {
              $config_path = '/etc/yum/yum-cron.conf'
              $debug_level = '-1'
              $conf_tpl = 'rhel7.erb'
              $schedule_tpl = 'rhel7.erb'
              $default_schedule_path = '/etc/cron.daily/0yum-daily.cron'
            }
            '6'     : {
              $config_path = '/etc/sysconfig/yum-cron'
              $debug_level = 1
              $conf_tpl = 'rhel6.erb'
              $schedule_tpl = 'rhel6.erb'
              $default_schedule_path = '/etc/cron.daily/0yum.cron'
            }
            '5'     : {
              $config_path = '/etc/sysconfig/yum-cron'
              $debug_level = 1
              $conf_tpl = 'rhel5.erb'
              $schedule_tpl = 'rhel5.erb'
              $default_schedule_path = '/etc/cron.daily/yum.cron'
            }
            default : {
              fail("Unsupported OS version ${::operatingsystemmajrelease}")
            }
          }
        }
      }
    }
    default  : {
      fail("Unsupported OS family ${::osfamily}")
    }
  }
}