# == Class: yum_autoupdate::params
#
class yum_autoupdate::params {
  case $::osfamily {
    'RedHat' : {
      case $::operatingsystem {
        # Fedora does not follow RHEL release numbers
        'Fedora' : {
          case $::operatingsystemmajrelease {
            /19|20/    : {
              $config_path = '/etc/yum/yum-cron.conf'
              $config_tpl = 'yum-cron-conf-fc1920.erb'
              $custom_script = false
              $debug_level = '-1'
            }
            /16|17|18/ : {
              $config_path = '/etc/sysconfig/yum-cron'
              $config_tpl = 'yum-cron-conf-fc161718.erb'
              $custom_script = true
              $script_path = '/usr/sbin/yum-cron'
              $script_tpl = 'yum-cron-script-fc161718.erb'
              $debug_level = 1
            }
            '15'       : {
              $config_path = '/etc/sysconfig/yum-cron'
              $config_tpl = 'yum-cron-conf-fc15.erb'
              $custom_script = true
              $script_path = '/etc/cron.daily/0yum.cron'
              $script_tpl = 'yum-cron-script-fc15.erb'
              $debug_level = 1
            }
            default    : {
              fail("Unsupported OS version ${::operatingsystemmajrelease}")
            }
          }
        }
        # all other RHEL-based OS
        default  : {
          case $::operatingsystemmajrelease {
            '7'     : {
              $config_path = '/etc/yum/yum-cron.conf'
              $config_tpl = 'yum-cron-conf-rhel7.erb'
              $custom_script = false
              $debug_level = '-1'
            }
            '6'     : {
              $config_path = '/etc/sysconfig/yum-cron'
              $config_tpl = 'yum-cron-conf-rhel6.erb'
              $custom_script = true
              $script_path = '/etc/cron.daily/0yum.cron'
              $script_tpl = 'yum-cron-script-rhel6.erb'
              $debug_level = 1
            }
            '5'     : {
              $config_path = '/etc/sysconfig/yum-cron'
              $config_tpl = 'yum-cron-conf-rhel5.erb'
              $custom_script = true
              $script_path = '/etc/cron.daily/yum.cron'
              $script_tpl = 'yum-cron-script-rhel5.erb'
              $debug_level = 1
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