# === Class: autoupdate::params
#
class autoupdate::params {
  case $::osfamily {
    'RedHat' : {
      case $::operatingsystem {
        'Fedora' : {
          fail("Unsupported OS ${::operatingsystem}")
        }
        default  : {
          case $::operatingsystemmajrelease {
            '7'     : {
              $config_file = '/etc/yum/yum-cron.conf'
              $custom_script = false
              $script_path = '/usr/sbin/yum-cron'
            }
            '6'     : {
              $config_file = '/etc/sysconfig/yum-cron'
              $custom_script = true
              $script_path = '/etc/cron.daily/0yum.cron'
            }
            '5'     : {
              $config_file = '/etc/sysconfig/yum-cron'
              $custom_script = true
              $script_path = '/etc/cron.daily/yum.cron'
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