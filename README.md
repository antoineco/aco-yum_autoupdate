#autoupdate

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [To Do](#to-do)

##Overview

The autoupdate module allows you to configure automatic updates on all [RHEL variants](http://en.wikipedia.org/wiki/List_of_Linux_distributions#RHEL-based).
**Fedora is not supported yet**.

##Module description

The yum-cron service enables scheduled system updates on RHEL-based systems. This module allows you to install and configure this service without the need to fiddle manually with configuration files, which may vary from one major version to the other on most RHEL-based distributions.

##Setup

autoupdate will affect the following parts of your system:

* yum-cron package and service
* yum cron configuration file(s)
* yum-cron script itself to implement extra features provided by this module

Including the main class is enough to get started. It will enable automatic updates check via a cron.daily task and apply all available updates whenever possible. Summary emails are sent to the local root user.

```puppet
    include ::autoupdate
```

####A couple of examples 

Disable emails (default) and just download updates, do not apply

```puppet
    class { '::autoupdate':
      debug_level => '0',
      error_level => '0',
      action      => 'download'
    }
```

Enable emails (debug/error levels are arbitrary). Send emails to a different receiver (local root account by default) and from a specific sender address 

```puppet
    class { '::autoupdate':
      debug_level => '1',
      error_level => '1',
      email_to    => 'admin@example.com',
      email_from  => 'sysupdates@example.com'
    }
```

Let crond send emails

```puppet
    class { '::autoupdate':
      email_to => ''
    }
```

Disable random delay

```puppet
    class { '::autoupdate':
      randomwait => '0'
    }
```

Exclude specific packages

```puppet
    class { '::autoupdate':
      exclude => ['httpd','puppet*']
    }
```

##Usage

####Class: `autoupdate`

Primary class and entry point of the module.

**Parameters within `autoupdate`:**

#####`action`

Mode in which yum-crom should perform. Valid values are 'check', 'download' and 'apply'. Defaults to 'apply'.

#####`exclude`

Array of packages to exclude from automatic update. Defaults to '[]'.

#####`service_enable`

Enable the service or not. Valid values are 'true' and 'false'. Defaults to 'true'.

#####`service_ensure`

Whether the service should be running. Valid values are 'stopped' and 'running'. Defaults to 'running'.

#####`email_to`

Recipient email address for update notifications. Defaults to 'root' (local user)

#####`email_from`

Sender email address for update notifications. No effect when `email_to` is empty. Defaults to 'root' (local user)

#####`error_level`

YUM error level. Valid values are numbers between 0 and 10. '0' to disable. Defaults to '0'.

#####`debug_level`

YUM debug level. Valid values are numbers between 0 and 10. '0' to disable. Defaults to '0'.

#####`randomwait`

Maximum amount of time in minutes YUM randomly waits before running. Valid values are numbers between 0 and 1440. '0' to disable. Defaults to '60'.

##To Do

* Support Fedora
* Add support for multiple schedules
* Add support for passing arbitrary parameters to YUM

Features request and contributions are always welcome!