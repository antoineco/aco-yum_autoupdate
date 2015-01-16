define yum_autoupdate::schedule (
  $action       = 'apply',
  $exclude      = [],
  $notify_email = true,
  $email_to     = 'root',
  $email_from   = 'root',
  $debug_level  = $yum_autoupdate::params::debug_level,
  $error_level  = 0,
  $update_cmd   = 'default',
  $randomwait   = 60,
  #cron attributes,
  $user         = root,
  $hour         = undef, 
  $minute       = undef,
  $month        = undef,
  $monthday     = undef,
  $weekday      = undef,
  $special      = undef) {
  # set real debug level
  $debug_level_real = $notify_email ? {
    false   => -1,
    default => $debug_level,
  }

  if $::operatingsystem != 'Fedora' and $::operatingsystemmajrelease < 7 {
    $exclude_real = join(prefix($exclude, '--exclude='), '\ ')
  } else {
    $exclude_real = join($exclude, ' ')
  }

  # config file
  $config_path = "${yum_autoupdate::params::default_config_path}_${name}"
  file { "yum-cron ${name} config":
    ensure  => present,
    path    => $config_path,
    content => template("${module_name}/conf/${yum_autoupdate::params::conf_tpl}"),
    mode    => '0644'
  }

  # schedule
  file { "yum-cron ${name} schedule":
    ensure  => present,
    path    => "/etc/yum/schedules/yum-cron_${name}",
    content => template("${module_name}/schedule/${yum_autoupdate::params::schedule_tpl}"),
    mode    => '0755'
  } ->
  cron { "yum-cron ${name} schedule":
    command  => "/etc/yum/schedules/yum-cron_${name}",
    user     => $user,
    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,
    special  => $special
  }
}